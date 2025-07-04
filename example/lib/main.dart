import 'dart:async';

import 'package:dev_analytics_dashboard/providers/analytics_provider.dart';
import 'package:dev_analytics_dashboard/widgets/analytics_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    final provider = AnalyticsProvider();
    provider.logError(details.exceptionAsString());
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsProvider(),
      child: MaterialApp(
        title: 'Dev Analytics Dashboard',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
        navigatorObservers: [AnalyticsNavigatorObserver()],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyticsProvider>(context);
    final gestureConfig = provider.gestureConfig;

    return GestureDetector(
      onTap: () {
        if (gestureConfig.tapCount == 1 && gestureConfig.fingerCount == 1) {
          provider.toggleDashboard();
        }
      },
      onDoubleTap: () {
        if (gestureConfig.tapCount == 2 && gestureConfig.fingerCount <= 2) {
          provider.toggleDashboard();
        }
      },
      onTapUp: (details) {
        if (gestureConfig.tapCount == 3 && gestureConfig.fingerCount <= 3) {
          Timer(const Duration(milliseconds: 300), () {
            provider.toggleDashboard();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SecondScreen()),
                      );
                    },
                    child: const Text('Go to Second Screen'),
                  ),
                ],
              ),
            ),
            const AnalyticsDashboard(),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: const Center(child: Text('Second Screen')),
    );
  }
}

class AnalyticsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final provider = navigator!.context.read<AnalyticsProvider>();
    provider.addUserFlow(route.settings.name ?? route.runtimeType.toString());
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final provider = navigator!.context.read<AnalyticsProvider>();
    provider.addUserFlow(
      previousRoute?.settings.name ?? previousRoute.runtimeType.toString(),
    );
  }
}
