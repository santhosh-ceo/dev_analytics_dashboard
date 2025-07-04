import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class DeviceInfoWidget extends StatelessWidget {
  const DeviceInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceInfo = Provider.of<AnalyticsProvider>(context).deviceInfo;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Device Info',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          if (deviceInfo != null) ...[
            Text(
              'Model: ${deviceInfo.model}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'OS Version: ${deviceInfo.osVersion}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Screen Size: ${deviceInfo.screenSize}',
              style: const TextStyle(color: Colors.white),
            ),
          ] else
            const Text('Loading...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
