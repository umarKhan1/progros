import Flutter
import UIKit

class SubscriptionPlugin: NSObject, FlutterPlugin {
    static let channelName = "progros/subscription"
    private var subscriptionManager: SubscriptionManager?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        let instance = SubscriptionPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    override init() {
        super.init()
        subscriptionManager = SubscriptionManager()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let manager = subscriptionManager else {
            result(FlutterError(code: "UNAVAILABLE", message: "Subscription manager not available", details: nil))
            return
        }
        
        switch call.method {
        case "getSubscriptionStatus":
            manager.fetchSubscriptionStatus { isActive in
                result(isActive)
            }
            
        case "startObservingSubscription":
            manager.startObservingSubscription()
            result(nil)
            
        case "detectRegionPreference":
            Task {
                await manager.detectRegionPreference()
                DispatchQueue.main.async {
                    result(manager.isStripePreferred)
                }
            }
            
        case "refreshEntitlementStatus":
            Task { @MainActor in
                manager.refreshEntitlementStatus { isActive in
                    result(isActive)
                }
            }
            
        case "fetchRevenueCatProducts":
            Task { @MainActor in
                let offeringId = (call.arguments as? [String: Any])?["offeringId"] as? String ?? "Subscriptions 2"
                manager.fetchRevenueCatProducts(offeringId: offeringId)
                result(nil)
            }
            
        case "restoreApplePurchases":
            manager.restoreApplePurchases { success in
                result(success)
            }
            
        case "cancelStripeSubscription":
            manager.cancelStripeSubscription { resultValue in
                switch resultValue {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(code: "CANCELLATION_FAILED", message: error.localizedDescription, details: nil))
                }
            }
            
        case "canAccessFeature":
            let canAccess = manager.canAccessFeature()
            result(canAccess)
            
        case "isSubscriptionOnlyFeatureAccessible":
            let accessible = manager.isSubscriptionOnlyFeatureAccessible()
            result(accessible)
            
        case "checkAndResetTokensIfNeeded":
            manager.checkAndResetTokensIfNeeded()
            result(nil)
            
        case "consumeDailyCharacters":
            guard let args = call.arguments as? [String: Any],
                  let charCount = args["charCount"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "charCount is required", details: nil))
                return
            }
            
            manager.consumeDailyCharactersIfAllowed(charCount) { allowed, remaining in
                result(["allowed": allowed, "remaining": remaining])
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}