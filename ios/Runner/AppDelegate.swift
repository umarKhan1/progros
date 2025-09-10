import Flutter
import UIKit
import GoogleMaps
import Firebase
import RevenueCat
import Stripe

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()
    
    // Configure RevenueCat
    Purchases.logLevel = .debug
    Purchases.configure(withAPIKey: "YOUR_REVENUECAT_API_KEY") // Replace with actual key
    
    // Configure Stripe
    StripeAPI.defaultPublishableKey = "YOUR_STRIPE_PUBLISHABLE_KEY" // Replace with actual key
    
    // Configure Google Maps
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCC2ZpWTa2HUPEADVMu8Lg_c1YvWUGLuNE")
    
    // Register custom subscription plugin
    let controller = window?.rootViewController as! FlutterViewController
    SubscriptionPlugin.register(with: self.registrar(forPlugin: "SubscriptionPlugin")!)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
