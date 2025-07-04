import 'package:flutter_test/flutter_test.dart';
import 'package:dev_analytics_dashboard/dev_analytics_dashboard.dart';
import 'package:dev_analytics_dashboard/dev_analytics_dashboard_platform_interface.dart';
import 'package:dev_analytics_dashboard/dev_analytics_dashboard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDevAnalyticsDashboardPlatform
    with MockPlatformInterfaceMixin
    implements DevAnalyticsDashboardPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DevAnalyticsDashboardPlatform initialPlatform = DevAnalyticsDashboardPlatform.instance;

  test('$MethodChannelDevAnalyticsDashboard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDevAnalyticsDashboard>());
  });

  test('getPlatformVersion', () async {
    DevAnalyticsDashboard devAnalyticsDashboardPlugin = DevAnalyticsDashboard();
    MockDevAnalyticsDashboardPlatform fakePlatform = MockDevAnalyticsDashboardPlatform();
    DevAnalyticsDashboardPlatform.instance = fakePlatform;

    expect(await devAnalyticsDashboardPlugin.getPlatformVersion(), '42');
  });
}
