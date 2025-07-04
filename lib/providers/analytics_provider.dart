import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:system_info2/system_info2.dart';

import '../models/device_info_model.dart';
import '../models/gesture_config.dart';
import '../models/log_entry.dart';
import '../models/user_flow.dart';
import '../services/cpu_monitor_service.dart';
import '../services/log_storage_service.dart';

class AnalyticsProvider with ChangeNotifier {
  bool _isDashboardVisible = false;
  DeviceInfoModel? _deviceInfo;
  double _fps = 0.0;
  int _memoryUsage = 0;
  double _cpuUsage = 0.0;
  final List<LogEntry> _logs = [];
  final List<UserFlow> _userFlows = [];
  GestureConfig _gestureConfig = GestureConfig(fingerCount: 2, tapCount: 2);
  final LogStorageService _logStorage = LogStorageService();
  final CpuMonitorService _cpuMonitor = CpuMonitorService();

  bool get isDashboardVisible => _isDashboardVisible;

  DeviceInfoModel? get deviceInfo => _deviceInfo;

  double get fps => _fps;

  int get memoryUsage => _memoryUsage;

  double get cpuUsage => _cpuUsage;

  List<LogEntry> get logs => _logs;

  List<UserFlow> get userFlows => _userFlows;

  GestureConfig get gestureConfig => _gestureConfig;

  AnalyticsProvider() {
    _init();
  }

  Future<void> _init() async {
    await _initLogs();
    await _fetchDeviceInfo();
    await _loadGestureConfig();
    await _loadPersistedLogs();
    _startPerformanceMonitoring();
  }

  Future<void> _initLogs() async {
    await FlutterLogs.initLogs(
      logLevelsEnabled: [LogLevel.INFO, LogLevel.ERROR],
      directoryStructure:
          DirectoryStructure.SINGLE_FILE_FOR_DAY, // Flat structure
      timeStampFormat:
          TimeStampFormat.TIME_FORMAT_READABLE, // Human-readable timestamp
      logFileExtension: LogFileExtension.TXT, // .txt extension for logs
    );
  }

  Future<void> _fetchDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final context = WidgetsBinding.instance.window;
    final screenSize = MediaQueryData.fromWindow(context).size;
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        _deviceInfo = DeviceInfoModel(
          model: androidInfo.model,
          osVersion: androidInfo.version.release,
          screenSize:
              '${screenSize.width.toInt()}x${screenSize.height.toInt()}',
        );
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        _deviceInfo = DeviceInfoModel(
          model: iosInfo.utsname.machine,
          osVersion: iosInfo.systemVersion,
          screenSize:
              '${screenSize.width.toInt()}x${screenSize.height.toInt()}',
        );
      }
      notifyListeners();
    } catch (e) {
      addLog(
        LogEntry(
          message: 'Error fetching device info: $e',
          timestamp: DateTime.now(),
          type: 'error',
        ),
      );
    }
  }

  Future<void> _loadPersistedLogs() async {
    _logs.addAll(await _logStorage.loadLogs());
    notifyListeners();
  }

  Future<void> _loadGestureConfig() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/gesture_config.json');
      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        _gestureConfig = GestureConfig.fromJson(json);
      }
    } catch (e) {
      print('Error loading gesture config: $e');
    }
    notifyListeners();
  }

  Future<void> saveGestureConfig(GestureConfig config) async {
    try {
      _gestureConfig = config;
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/gesture_config.json');
      await file.writeAsString(jsonEncode(config.toJson()));
      notifyListeners();
    } catch (e) {
      print('Error saving gesture config: $e');
    }
  }

  void _startPerformanceMonitoring() {
    // Simulate FPS updates (since StatsFl doesn't provide programmatic access)
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // Approximate FPS based on timer; ideal range is 30-60 for most devices
      _fps =
          (_fps > 0 ? _fps : 60.0) *
          (0.95 + 0.1 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000);
      notifyListeners();
    });

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      _memoryUsage = SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024);
      _cpuUsage = await _cpuMonitor.getCpuUsage();
      notifyListeners();
    });
  }

  void toggleDashboard() {
    _isDashboardVisible = !_isDashboardVisible;
    notifyListeners();
  }

  void addLog(LogEntry log) {
    _logs.add(log);
    FlutterLogs.logThis(
      tag: 'Analytics',
      subTag: log.type,
      logMessage: log.message,
      level: log.type == 'error' ? LogLevel.ERROR : LogLevel.INFO,
    );
    if (_logs.length > 100) _logs.removeAt(0);
    _logStorage.saveLogs(_logs);
    notifyListeners();
  }

  void addUserFlow(String screenName) {
    _userFlows.add(UserFlow(screenName: screenName, timestamp: DateTime.now()));
    addLog(
      LogEntry(
        message: 'Navigated to $screenName',
        timestamp: DateTime.now(),
        type: 'navigation',
      ),
    );
    notifyListeners();
  }

  void logError(String error) {
    addLog(LogEntry(message: error, timestamp: DateTime.now(), type: 'error'));
  }
}
