import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  var initialLink: URL?
  var flutterEngine: FlutterEngine?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    flutterEngine = FlutterEngine(name: "app_link_engine")
    flutterEngine?.run()
    GeneratedPluginRegistrant.register(with: flutterEngine!)

    let channel = FlutterMethodChannel(
      name: "app.linking.channel",
      binaryMessenger: flutterEngine!.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] (call, result) in 
      if call.method == "getLaunchUri" {
        result(self?.initialLink?.absoluteString)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    if let flutterEngine = flutterEngine {
      let flutterViewController = FlutterViewController(
        engine: flutterEngine,
        nibName: nil,
        bundle: nil
      )
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = flutterViewController
      window?.makeKeyAndVisible()
    }
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    initialLink = url
    return true
  }
}
