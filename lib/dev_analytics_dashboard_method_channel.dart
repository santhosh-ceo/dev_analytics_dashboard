import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dev_analytics_dashboard_platform_interface.dart';

/// An implementation of [DevAnalyticsDashboardPlatform] that uses method channels.
class MethodChannelDevAnalyticsDashboard extends DevAnalyticsDashboardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dev_analytics_dashboard');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
