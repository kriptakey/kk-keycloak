import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  var initialLink: URL?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let url = launchOptions?[.url] as? URL {
      initialLink = url
    }

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "app.linking.channel", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call, result) in 
      if call.method == "getLaunchUri" {
        result(self?.initialLink?.absoluteString)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
