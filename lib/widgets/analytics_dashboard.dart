import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsfl/statsfl.dart';

import '../providers/analytics_provider.dart';
import '../screens/settings_screen.dart';
import 'device_info_widget.dart';
import 'logs_widget.dart';
import 'performance_widget.dart';
import 'user_flow_widget.dart';

class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyticsProvider>(context);
    if (!provider.isDashboardVisible) return const SizedBox.shrink();

    return StatsFl(
      isEnabled: provider.isDashboardVisible,
      align: Alignment.topLeft,
      child: Positioned(
        top: 20,
        right: 20,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dev Analytics Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const DeviceInfoWidget(),
                const PerformanceWidget(),
                const LogsWidget(),
                const UserFlowWidget(),
                TextButton(
                  onPressed: provider.toggleDashboard,
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
