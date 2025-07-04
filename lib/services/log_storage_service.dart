import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/log_entry.dart';

class LogStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/analytics_logs.json');
  }

  Future<void> saveLogs(List<LogEntry> logs) async {
    try {
      final file = await _localFile;
      final jsonLogs =
          logs
              .map(
                (log) => {
                  'message': log.message,
                  'timestamp': log.timestamp.toIso8601String(),
                  'type': log.type,
                },
              )
              .toList();
      await file.writeAsString(jsonEncode(jsonLogs));
    } catch (e) {
      print('Error saving logs: $e');
    }
  }

  Future<List<LogEntry>> loadLogs() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      final jsonString = await file.readAsString();
      final jsonLogs = jsonDecode(jsonString) as List;
      return jsonLogs
          .map(
            (json) => LogEntry(
              message: json['message'],
              timestamp: DateTime.parse(json['timestamp']),
              type: json['type'],
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading logs: $e');
      return [];
    }
  }
}
