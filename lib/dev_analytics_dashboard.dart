import 'dev_analytics_dashboard_platform_interface.dart';

class DevAnalyticsDashboard {
  Future<String?> getPlatformVersion() {
    return DevAnalyticsDashboardPlatform.instance.getPlatformVersion();
  }
}
