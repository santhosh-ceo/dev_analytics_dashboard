import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dev_analytics_dashboard_method_channel.dart';

abstract class DevAnalyticsDashboardPlatform extends PlatformInterface {
  /// Constructs a DevAnalyticsDashboardPlatform.
  DevAnalyticsDashboardPlatform() : super(token: _token);

  static final Object _token = Object();

  static DevAnalyticsDashboardPlatform _instance =
      MethodChannelDevAnalyticsDashboard();

  /// The default instance of [DevAnalyticsDashboardPlatform] to use.
  ///
  /// Defaults to [MethodChannelDevAnalyticsDashboard].
  static DevAnalyticsDashboardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DevAnalyticsDashboardPlatform] when
  /// they register themselves.
  static set instance(DevAnalyticsDashboardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
