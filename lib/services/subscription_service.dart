import 'package:flutter/services.dart';

class SubscriptionService {
  static const MethodChannel _channel = MethodChannel('progros/subscription');

  /// Get current subscription status
  static Future<bool> getSubscriptionStatus() async {
    try {
      final bool result = await _channel.invokeMethod('getSubscriptionStatus');
      return result;
    } catch (e) {
      print('Error getting subscription status: $e');
      return false;
    }
  }

  /// Start observing subscription changes
  static Future<void> startObservingSubscription() async {
    try {
      await _channel.invokeMethod('startObservingSubscription');
    } catch (e) {
      print('Error starting subscription observation: $e');
    }
  }

  /// Detect region preference for payment methods
  static Future<bool> detectRegionPreference() async {
    try {
      final bool isStripePreferred = await _channel.invokeMethod('detectRegionPreference');
      return isStripePreferred;
    } catch (e) {
      print('Error detecting region preference: $e');
      return false;
    }
  }

  /// Refresh entitlement status from RevenueCat
  static Future<bool> refreshEntitlementStatus() async {
    try {
      final bool isActive = await _channel.invokeMethod('refreshEntitlementStatus');
      return isActive;
    } catch (e) {
      print('Error refreshing entitlement status: $e');
      return false;
    }
  }

  /// Fetch available products from RevenueCat
  static Future<void> fetchRevenueCatProducts({String offeringId = "Subscriptions 2"}) async {
    try {
      await _channel.invokeMethod('fetchRevenueCatProducts', {'offeringId': offeringId});
    } catch (e) {
      print('Error fetching RevenueCat products: $e');
    }
  }

  /// Restore Apple purchases
  static Future<bool> restoreApplePurchases() async {
    try {
      final bool success = await _channel.invokeMethod('restoreApplePurchases');
      return success;
    } catch (e) {
      print('Error restoring Apple purchases: $e');
      return false;
    }
  }

  /// Cancel Stripe subscription
  static Future<bool> cancelStripeSubscription() async {
    try {
      final bool success = await _channel.invokeMethod('cancelStripeSubscription');
      return success;
    } catch (e) {
      print('Error canceling Stripe subscription: $e');
      return false;
    }
  }

  /// Check if user can access premium features
  static Future<bool> canAccessFeature() async {
    try {
      final bool canAccess = await _channel.invokeMethod('canAccessFeature');
      return canAccess;
    } catch (e) {
      print('Error checking feature access: $e');
      return false;
    }
  }

  /// Check if subscription-only features are accessible
  static Future<bool> isSubscriptionOnlyFeatureAccessible() async {
    try {
      final bool accessible = await _channel.invokeMethod('isSubscriptionOnlyFeatureAccessible');
      return accessible;
    } catch (e) {
      print('Error checking subscription feature access: $e');
      return false;
    }
  }

  /// Check and reset daily tokens if needed
  static Future<void> checkAndResetTokensIfNeeded() async {
    try {
      await _channel.invokeMethod('checkAndResetTokensIfNeeded');
    } catch (e) {
      print('Error checking/resetting tokens: $e');
    }
  }

  /// Consume daily characters if allowed
  static Future<Map<String, dynamic>> consumeDailyCharacters(int charCount) async {
    try {
      final Map<String, dynamic> result = Map<String, dynamic>.from(
        await _channel.invokeMethod('consumeDailyCharacters', {'charCount': charCount})
      );
      return result;
    } catch (e) {
      print('Error consuming daily characters: $e');
      return {'allowed': false, 'remaining': 0};
    }
  }
}

// Example usage in a widget:
/*
class SubscriptionWidget extends StatefulWidget {
  @override
  _SubscriptionWidgetState createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  bool _isSubscribed = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initSubscription();
  }

  Future<void> _initSubscription() async {
    setState(() => _loading = true);
    
    await SubscriptionService.startObservingSubscription();
    final isSubscribed = await SubscriptionService.getSubscriptionStatus();
    
    setState(() {
      _isSubscribed = isSubscribed;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    }

    return Column(
      children: [
        Text(_isSubscribed ? 'Premium User' : 'Free User'),
        ElevatedButton(
          onPressed: () async {
            if (_isSubscribed) {
              await SubscriptionService.cancelStripeSubscription();
            } else {
              // Handle subscription purchase
              await SubscriptionService.fetchRevenueCatProducts();
            }
          },
          child: Text(_isSubscribed ? 'Cancel' : 'Subscribe'),
        ),
      ],
    );
  }
}
*/