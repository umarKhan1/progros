# iOS Subscription Manager Setup Guide

## Overview
This document provides setup instructions for the SubscriptionManager Swift implementation in the progros Flutter app.

## Required Changes

### 1. API Keys Configuration
Replace placeholder API keys in `AppDelegate.swift`:

```swift
// Replace these with your actual keys:
Purchases.configure(withAPIKey: "YOUR_REVENUECAT_API_KEY")
StripeAPI.defaultPublishableKey = "YOUR_STRIPE_PUBLISHABLE_KEY"
```

### 2. Merchant ID Configuration
Update the merchant ID in `SubscriptionManager.swift`:
```swift
let applePayMerchantId = "merchant.bypassai" // Update with your merchant ID
```

### 3. Firebase Configuration
Ensure you have a valid `GoogleService-Info.plist` file in your iOS project.

### 4. Required iOS Capabilities
Add these capabilities in Xcode:
- Apple Pay Payment Processing
- In-App Purchase
- Push Notifications
- Background App Refresh

### 5. Dependencies
The following pods have been added to the Podfile:
- RevenueCat (~> 4.0)
- Stripe (~> 23.0)
- Firebase/Auth
- Firebase/Firestore
- Firebase/Functions

### 6. StoreKit Products
Configure these product IDs in App Store Connect:
- monthlyunlimited (monthly subscription)
- weeklyunlimited (weekly subscription)

### 7. Build and Run
1. Run `pod install` in the ios directory
2. Open `Runner.xcworkspace` in Xcode
3. Build and test the implementation

## Potential Issues and Solutions

### Import Errors
If you encounter import errors for Stripe modules:
- Ensure you're using Stripe SDK version 23.x or later
- Check that StripePayments and StripeApplePay modules are available

### RevenueCat Issues
- Make sure you've configured your RevenueCat offering with ID "Subscriptions 2"
- Verify product IDs match between App Store Connect and RevenueCat

### Firebase Issues
- Ensure Firebase is properly initialized
- Check that Firestore security rules allow the required operations

### Location Services
- Verify location permissions are properly configured in Info.plist
- Test location authorization flow

## Testing
- Test Apple Pay functionality with real device (simulator won't work)
- Verify subscription status synchronization with Firebase
- Test restore purchases functionality
- Validate token usage limits

## Integration with Flutter
To use this from Flutter, you can use the provided `SubscriptionService` class in `lib/services/subscription_service.dart`.

### Example Usage:
```dart
import 'package:progros/services/subscription_service.dart';

// Check subscription status
bool isSubscribed = await SubscriptionService.getSubscriptionStatus();

// Start observing subscription changes
await SubscriptionService.startObservingSubscription();

// Check if user can access premium features
bool canAccess = await SubscriptionService.canAccessFeature();

// Consume daily characters
var result = await SubscriptionService.consumeDailyCharacters(100);
bool allowed = result['allowed'];
int remaining = result['remaining'];
```

## Files Created/Modified

### iOS Files:
- `ios/Runner/SubscriptionManager.swift` - Main subscription management logic
- `ios/Runner/SubscriptionPlugin.swift` - Flutter method channel bridge
- `ios/Runner/AppDelegate.swift` - Updated with service initialization
- `ios/Podfile` - Added required dependencies
- `ios/Runner/Info.plist` - Added required permissions
- `ios/SETUP_GUIDE.md` - This setup guide

### Flutter Files:
- `lib/services/subscription_service.dart` - Dart service to communicate with iOS

## Next Steps
1. Replace placeholder API keys with actual values
2. Run `pod install` in the ios directory
3. Configure Apple Pay merchant ID
4. Set up App Store Connect products
5. Configure RevenueCat offerings
6. Test on a real device (Apple Pay requires physical device)