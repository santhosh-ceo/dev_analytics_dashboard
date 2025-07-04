import 'package:flutter/services.dart';

class CpuMonitorService {
  static const platform = MethodChannel('com.example/cpu_usage');

  Future<double> getCpuUsage() async {
    try {
      final double usage = await platform.invokeMethod('getCpuUsage');
      return usage;
    } catch (e) {
      print('Error fetching CPU usage: $e');
      return 0.0;
    }
  }
}
