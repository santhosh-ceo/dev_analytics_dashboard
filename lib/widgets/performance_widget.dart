import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class PerformanceWidget extends StatelessWidget {
  const PerformanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyticsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            'FPS: ${provider.fps.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            'Memory Usage: ${provider.memoryUsage} MB',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            'CPU Usage: ${provider.cpuUsage.toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
