# Flutter Dev Analytics Dashboard

A Flutter in-app widget for developers to monitor device info, performance metrics, screen logs, errors, and user flow during development. The dashboard can be toggled with a customizable gesture and is designed for high-quality, modular use in Flutter applications.

[![Pub Version](https://img.shields.io/pub/v/offline_sync_manager)](https://pub.dev/packages/dev_analytics_dashboard)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


![Dashboard Screenshot](screenshots/dashboard.png) <!-- Replace with actual screenshot -->

## Features

- **Device Info**: Displays device model, OS version, and screen size.
- **Performance Metrics**: Tracks FPS (simulated and visually via `statsfl`), memory usage, and CPU usage in real-time.
- **Screen Logs**: Logs navigation, interactions, and errors, persisted to disk.
- **Error Tracking**: Captures uncaught exceptions and displays them.
- **User Flow Visualization**: Shows navigation paths as a bar chart using `fl_chart`.
- **Gesture Toggle**: Customizable gesture (finger count, tap count) to show/hide the dashboard.
- **Settings**: Configure gesture triggers via an in-app settings screen.

## Requirements

- Flutter SDK: 3.24 or later
- Dart: 3.5 or later
- Platforms: Android (API 21+), iOS (12.0+)
- Development Environment: VS Code, Android Studio, or any Flutter-compatible IDE

## Installation

### Prerequisites

1. Install Flutter: Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
2. Ensure you have an emulator or physical device set up for testing.

### Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/dev-analytics-dashboard.git
   cd dev-analytics-dashboard
   ```

Install Dependencies:
Update pubspec.yaml with the required packages and run:
```
flutter pub get
```

Platform-Specific Setup:

Android:
Add the following to android/app/src/main/kotlin/com/example/dev_analytics_dashboard/MainActivity.kt for CPU usage monitoring:
```
package com.example.dev_analytics_dashboard

import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.FileReader

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example/cpu_usage"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getCpuUsage") {
                val cpuUsage = getCpuUsage()
                result.success(cpuUsage)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getCpuUsage(): Double {
        try {
            val reader = BufferedReader(FileReader("/proc/stat"))
            val cpuLine = reader.readLine()
            reader.close()

            val stats = cpuLine.split("\\s+".toRegex()).drop(1).map { it.toLong() }
            val idle = stats[3]
            val total = stats.sum()

            Thread.sleep(100)

            val reader2 = BufferedReader(FileReader("/proc/stat"))
            val cpuLine2 = reader2.readLine()
            reader2.close()

            val stats2 = cpuLine2.split("\\s+".toRegex()).drop(1).map { it.toLong() }
            const idle2 = stats2[3]
            const total2 = stats2.sum()

            const usage = (1.0 - (idle2 - idle).toDouble() / (total2 - total)) * 100
            return usage
        } catch (e: Exception) {
            return 0.0
        }
    }
}
```

Update android/app/build.gradle:
```
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = '1.8'
    }
}
```

iOS:
Add the following to ios/Runner/AppDelegate.swift for CPU usage monitoring:
```
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let cpuChannel = FlutterMethodChannel(name: "com.example/cpu_usage", binaryMessenger: controller.binaryMessenger)

    cpuChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getCpuUsage" {
        result(self.getCpuUsage())
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getCpuUsage() -> Double {
    var totalUsage: Double = 0
    var threadList: thread_act_array_t?
    var threadCount: mach_msg_type_number_t = 0
    let kerr = task_threads(mach_task_self_, &threadList, &threadCount)

    guard kerr == KERN_SUCCESS, let threads = threadList else { return 0 }

    for i in 0..<threadCount {
      var threadInfo = thread_basic_info()
      var threadInfoCount = mach_msg_type_number_t(THREAD_BASIC_INFO_COUNT)
      let kerr2 = thread_info(threads[Int(i)], THREAD_BASIC_INFO, &threadInfo, &threadInfoCount)
      if kerr2 == KERN_SUCCESS {
        if (threadInfo.flags & TH_FLAGS_IDLE) == 0 {
          totalUsage += Double(threadInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100
        }
      }
    }

    vm_deallocate(mach_task_self_, UInt(threadList!), UInt(threadCount * MemoryLayout<thread_act_t>.size))
    return totalUsage
  }
}
```
Ensure ios/Podfile specifies:
```
platform :ios, '12.0'
```

## Usage

Toggle the Dashboard:Default gesture: Two-finger double-tap.
Customize the gesture (finger count, tap count) via the settings screen, accessible from the dashboard's settings icon.

Monitor Analytics:Device Info: View device model, OS version, and screen size.
Performance: Track FPS (simulated and visually via statsfl), memory usage, and CPU usage in real-time.
Logs: View navigation, interaction, and error logs, persisted to disk.
User Flow: Visualize screen visits as a bar chart and detailed list.
Errors: See uncaught exceptions logged automatically.

Navigate the App:Use the sample app’s “Home” and “Second Screen” to test navigation and user flow tracking.
Integrate the dashboard into your own Flutter app by adding the AnalyticsDashboard widget to your widget tree.


## Contributing
Contributions are welcome! Please open an issue or PR on GitHub.

### Notes
- **Quality**: The code is modular, type-safe, and follows Dart/Flutter best practices. It includes error handling, retries, and conflict resolution.
- **Extensibility**: You can extend the plugin by adding support for other databases (e.g., Drift) or sync protocols (e.g., WebSocket).
- **Testing**: Add unit tests in `test/` for production use. I can provide test code if needed.
- **Premium Support**: As a premium user, let me know if you need additional features, optimizations, or help setting up the server.

If you encounter issues or need further customization, please provide details, and I’ll assist promptly!

## Acknowledgements
#### Built with ❤️ by Santhosh Adiga U



