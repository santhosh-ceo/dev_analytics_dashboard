import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gesture_config.dart';
import '../providers/analytics_provider.dart';

class GestureSettingsWidget extends StatefulWidget {
  const GestureSettingsWidget({super.key});

  @override
  _GestureSettingsWidgetState createState() => _GestureSettingsWidgetState();
}

class _GestureSettingsWidgetState extends State<GestureSettingsWidget> {
  late int _fingerCount;
  late int _tapCount;

  @override
  void initState() {
    super.initState();
    final config = context.read<AnalyticsProvider>().gestureConfig;
    _fingerCount = config.fingerCount;
    _tapCount = config.tapCount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gesture Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DropdownButton<int>(
          value: _fingerCount,
          items:
              [1, 2, 3].map((count) {
                return DropdownMenuItem(
                  value: count,
                  child: Text('$count Finger(s)'),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _fingerCount = value;
              });
            }
          },
        ),
        DropdownButton<int>(
          value: _tapCount,
          items:
              [1, 2, 3].map((count) {
                return DropdownMenuItem(
                  value: count,
                  child: Text('$count Tap(s)'),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _tapCount = value;
              });
            }
          },
        ),
        ElevatedButton(
          onPressed: () {
            final provider = context.read<AnalyticsProvider>();
            provider.saveGestureConfig(
              GestureConfig(fingerCount: _fingerCount, tapCount: _tapCount),
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
