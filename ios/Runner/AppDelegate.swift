import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

	// Added by JSB while implementing notifications
	// "This is required to make any communication available in the action isolate."
	//		Can possibly comment this specific part out if it causes any issues
	//		since I don't think we need it?
	// Some other possible configuration changes that I did not make:
	// https://pub.dev/packages/flutter_local_notifications#-usage
	// Specifically:
	// https://pub.dev/packages/flutter_local_notifications#:~:text=the%20onDidReceiveBackgroundNotificationResponse%20callback-,Configuration,-%3A
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDh5B5gBL-Syj0cWd73QPa1_FsEmdIUGWo")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
