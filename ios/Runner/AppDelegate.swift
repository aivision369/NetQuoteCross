import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
 private let CHANNEL = "com.aivision.today.today/dataUsage"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let dataUsageChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

    if #available(iOS 12.0, *) {
        let usageStatsService = UsageStatsService()
                dataUsageChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                    if call.method == "getDailyDataUsage" {
                        usageStatsService.getDailyDataUsage { dataUsage in
                            result(dataUsage)
                        }
                    } else {
                        result(FlutterMethodNotImplemented)
                    }
                }
            } else {
                dataUsageChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                    result(FlutterMethodNotImplemented)
                }
            }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
