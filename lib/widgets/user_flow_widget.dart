import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/analytics_provider.dart';

class UserFlowWidget extends StatelessWidget {
  const UserFlowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userFlows = Provider.of<AnalyticsProvider>(context).userFlows;

    final screenCounts = <String, int>{};
    for (var flow in userFlows) {
      screenCounts[flow.screenName] = (screenCounts[flow.screenName] ?? 0) + 1;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Flow',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups:
                    screenCounts.entries.toList().asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.value.toDouble(),
                            color: Colors.blue,
                            width: 20,
                          ),
                        ],
                      );
                    }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          screenCounts.keys.elementAt(value.toInt()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: userFlows.length,
              itemBuilder: (context, index) {
                final flow = userFlows[index];
                return Text(
                  '${flow.timestamp.toIso8601String()}: ${flow.screenName}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
