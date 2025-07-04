import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_analytics_dashboard/dev_analytics_dashboard_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDevAnalyticsDashboard platform = MethodChannelDevAnalyticsDashboard();
  const MethodChannel channel = MethodChannel('dev_analytics_dashboard');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
