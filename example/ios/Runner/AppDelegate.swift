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