import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  var flutterEngine: FlutterEngine!
  var methodChannel: FlutterMethodChannel?
  var latestUniversalLink: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    flutterEngine = FlutterEngine(name: "my_flutter_engine")
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)

    // Set FlutterViewController as rootViewController
    let flutterViewController = FlutterViewController(engine: flutterEngine, nibName:nil, bundle: nil)
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = flutterViewController
    window?.makeKeyAndVisible()

    methodChannel = FlutterMethodChannel(name: "app.linking.channel", binaryMessenger: flutterViewController.binaryMessenger)

    methodChannel?.setMethodCallHandler { [weak self] call, result in
      if call.method == "getInitialLink" {
        result(self?.latestUniversalLink ?? "No link")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping([UIUserActivityRestoring]?) -> Void) -> Bool {
      if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let incomingURL = userActivity.webpageURL?.absoluteString {
          latestUniversalLink = incomingURL
          NSLog("Received universal link: \(incomingURL)")
          methodChannel?.invokeMethod("onUniversalLink", arguments: incomingURL)
        }
        return true
  }
}
