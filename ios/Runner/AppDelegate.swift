import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDh5B5gBL-Syj0cWd73QPa1_FsEmdIUGWo")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
