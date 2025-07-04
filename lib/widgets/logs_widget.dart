import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class LogsWidget extends StatelessWidget {
  const LogsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = Provider.of<AnalyticsProvider>(context).logs;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logs',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Text(
                  '[${log.timestamp.toIso8601String()}] ${log.type}: ${log.message}',
                  style: TextStyle(
                    color: log.type == 'error' ? Colors.red : Colors.white,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
