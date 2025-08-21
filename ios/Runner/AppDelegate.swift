import Flutter
import UIKit
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     GMSServices.provideAPIKey("AIzaSyCC2ZpWTa2HUPEADVMu8Lg_c1YvWUGLuNE")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

  }
}
