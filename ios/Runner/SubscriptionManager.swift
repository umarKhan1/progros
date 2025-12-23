import Foundation
import SwiftUI
import StoreKit
import RevenueCat

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

import CoreLocation
import PassKit

// Stripe (24.23.x modular imports)
import Stripe            // StripeAPI.paymentRequest(...)
import StripePayments    // STPPaymentMethod, PK* helpers
import StripeApplePay    // STPApplePayContext

// MARK: - Location

final class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var completion: ((String) -> Void)?

    func fetchCountryCode(_ completion: @escaping (String) -> Void) {
        self.completion = completion
        manager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways: manager.requestLocation()
        case .denied, .restricted: fire("US")
        @unknown default: fire("US")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways: manager.requestLocation()
        case .denied, .restricted: fire("US")
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { fire("US"); return }
        CLGeocoder().reverseGeocodeLocation(loc) { placemarks, _ in
            let code = placemarks?.first?.isoCountryCode?.uppercased() ?? "US"
            self.fire(code)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fire("PT") // keep your override fallback
    }

    private func fire(_ code: String) {
        guard let completion = completion else { return }
        self.completion = nil
        completion(code)
    }
}

// MARK: - Products

enum IAPProduct: String, CaseIterable {
    case monthly = "monthlyunlimited"
    case weekly  = "weeklyunlimited"
}

enum SubscriptionProvider { case none, stripe, apple }

// MARK: - Subscription Manager

final class SubscriptionManager: NSObject, ObservableObject {

    // Public state
    @Published var isSubscriptionActive = false
    @Published var provider: SubscriptionProvider = .none
    @Published var isStripePreferred = true

    // RevenueCat products for Apple IAP
    @Published var rcProducts: [StoreProduct] = []

    // Tokens, diamonds, errors
    @Published var totalDiamonds = 0
    @Published var totaltokenUsage = 0
    @Published var tokensLeft = 10000
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Apple entitlement snapshot
    @Published private(set) var appleEntitled = false

    // Services
    private let locationService = LocationService()
    private var listener: ListenerRegistration?
    lazy var fx: Functions = { Functions.functions(region: "us-central1") }()

    // Stripe Apple Pay
    let applePayMerchantId = "merchant.bypassai"
    private let merchantCountryCode = "US"        // merchant's country (not user's)
    private var isCancelling = false

    // Firestore keys
    private let wasAppleActiveKey = "wasAppleActive"
    private let subscriptionDoc = "subscriptions"

    // RevenueCat cache
    @Published var rcReady = false
    private var rcMap: [IAPProduct: StoreProduct] = [:]
    func productFor(_ p: IAPProduct) -> StoreProduct? { rcMap[p] }

    // Apple Pay session state that the delegate methods will use
    private var applePayContext: STPApplePayContext?
    private var pendingClientSecret: String?
    private var pendingSubscriptionId: String?
    private var pendingAfterFinish: ((Result<Void, Error>) -> Void)?
    private var pendingFinalize: ((_ subscriptionId: String, _ completion: @escaping (Result<Void, Error>) -> Void) -> Void)?

    // Init / deinit
    override init() { super.init() }
    deinit { listener?.remove() }

    // MARK: - Boot

    func startObservingSubscription() { observeSubscriptionStatus() }

    // MARK: - Fetch one-shot status

    func fetchSubscriptionStatus(completion: @escaping (Bool) -> Void) {
        guard let uid = currentUid else { completion(false); return }

        Firestore.firestore().collection(subscriptionDoc).document(uid).getDocument { [weak self] snap, _ in
            guard let self = self else { return }
            let data = snap?.data() ?? [:]

            let activeFS: Bool = {
                if let a = data["active"] as? Bool { return a }
                if let s = (data["status"] as? String)?.lowercased() { return s == "active" || s == "trialing" }
                if let cape = data["cancelAtPeriodEnd"] as? Bool, cape { return false }
                return false
            }()

            let finalActive = self.appleEntitled || activeFS

            var newProvider: SubscriptionProvider = .none
            if self.appleEntitled { newProvider = .apple }
            else if let p = (data["provider"] as? String)?.lowercased(), p == "apple" { newProvider = .apple }
            else if data["stripeSubscriptionId"] != nil || data["stripeCustomerId"] != nil { newProvider = .stripe }

            DispatchQueue.main.async {
                if !(self.isSubscriptionActive && !finalActive) { self.isSubscriptionActive = finalActive }
                self.provider = newProvider
                completion(finalActive)
            }
        }
    }

    // MARK: - Free quota

    private func dailyCap(isSubscribed: Bool) -> Int { isSubscribed ? Int.max : 7_500 }

    func consumeDailyCharactersIfAllowed(_ charCount: Int,
                                         completion: @escaping (_ allowed: Bool, _ remaining: Int) -> Void) {
        if isSubscriptionActive { completion(true, Int.max); return }

        guard let uid = Auth.auth().currentUser?.uid
              ?? UserDefaultsHelper.getData(type: String.self, forKey: .userId) else {
            completion(false, 0); return
        }

        let userRef = Firestore.firestore().collection("users").document(uid)
        let maxPerDay = dailyCap(isSubscribed: false)
        let day: TimeInterval = 24 * 60 * 60

        Firestore.firestore().runTransaction({ (tx, errorPointer) -> Any? in
            do {
                let snap = try tx.getDocument(userRef)
                var data = snap.data() ?? [:]

                var used = data["tokenUsage"] as? Int ?? 0
                let lastReset = (data["tokenResetAt"] as? Timestamp)?.dateValue()
                let now = Date()

                if lastReset == nil || now.timeIntervalSince(lastReset!) >= day {
                    used = 0
                    data["tokenResetAt"] = Timestamp(date: now)
                }

                let newUsed = used + charCount
                if newUsed > maxPerDay {
                    tx.setData(data, forDocument: userRef, merge: true)
                    return ["ok": false, "remaining": maxPerDay - used]
                }

                data["tokenUsage"] = newUsed
                tx.setData(data, forDocument: userRef, merge: true)
                return ["ok": true, "remaining": maxPerDay - newUsed]
            } catch let e as NSError {
                errorPointer?.pointee = e
                return nil
            }
        }, completion: { result, error in
            if let _ = error { completion(false, 0); return }
            guard let dict = result as? [String: Any],
                  let ok = dict["ok"] as? Bool,
                  let remaining = dict["remaining"] as? Int else {
                completion(false, 0); return
            }
            completion(ok, remaining)
        })
    }

    // MARK: - Region choice (US -> Stripe/Apple Pay)

    @MainActor
    func detectRegionPreference() async {
        isStripePreferred = false
        if #available(iOS 15.0, *) {
            if let storefront = await Storefront.current {
                isStripePreferred = storefront.countryCode.uppercased() == "US"
                if isStripePreferred { return }
            }
        }
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            locationService.fetchCountryCode { code in
                self.isStripePreferred = (code.uppercased() == "US" || code.uppercased() == "USA")
                cont.resume()
            }
        }
    }

    // MARK: - Firestore listener

    private func observeSubscriptionStatus() {
        guard let uid = currentUid else { return }
        listener?.remove()
        listener = Firestore.firestore()
            .collection(subscriptionDoc)
            .document(uid)
            .addSnapshotListener { [weak self] snap, _ in
                guard let self = self else { return }
                let data = snap?.data() ?? [:]
                let isActiveFromFirestore = self.computeActive(from: data)
                let finalActive = self.appleEntitled || isActiveFromFirestore

                DispatchQueue.main.async {
                    if self.isSubscriptionActive && !finalActive { return }
                    self.isSubscriptionActive = finalActive
                    self.provider = self.inferProvider(from: data)
                }
            }
    }

    private func computeActive(from data: [String: Any]) -> Bool {
        if let active = data["active"] as? Bool { return active }
        if let status = (data["status"] as? String)?.lowercased() { return status == "active" || status == "trialing" }
        if let cape = data["cancelAtPeriodEnd"] as? Bool, cape { return false }
        return false
    }

    private func inferProvider(from data: [String: Any]) -> SubscriptionProvider {
        if appleEntitled { return .apple }
        if data["stripeSubscriptionId"] != nil { return .stripe }
        if data["stripeCustomerId"] != nil { return .stripe }
        if let p = (data["provider"] as? String)?.lowercased(), p == "stripe" { return .stripe }
        if let p = (data["provider"] as? String)?.lowercased(), p == "apple" { return .apple }
        return .none
    }

    // MARK: - RevenueCat helpers

    @MainActor
    func refreshEntitlementStatus(_ done: ((Bool)->Void)? = nil) {
        Purchases.shared.getCustomerInfo { [weak self] info, _ in
            guard let self = self else { done?(false); return }
            let active = !(info?.activeSubscriptions.isEmpty ?? true)
            self.appleEntitled = active
            if active {
                self.isSubscriptionActive = true
                self.provider = .apple
                Task { @MainActor in await self.ensureAppleDocInFirestore() }
            }
            done?(active)
        }
    }

    @MainActor
    func fetchRevenueCatProducts(offeringId: String = "Subscriptions 2") {
        Purchases.shared.getOfferings { offerings, error in
            if let error = error {
                print("RC error:", error.localizedDescription)
                self.rcMap = [:]; self.rcProducts = []; self.rcReady = false
                return
            }
            guard let offerings = offerings else {
                self.rcMap = [:]; self.rcProducts = []; self.rcReady = false
                return
            }
            let off = offerings.offering(identifier: offeringId)
                ?? offerings.current
                ?? offerings.all.values.first
            guard let off else {
                self.rcMap = [:]; self.rcProducts = []; self.rcReady = false
                return
            }

            var map: [IAPProduct: StoreProduct] = [:]
            for pkg in off.availablePackages {
                let id = pkg.storeProduct.productIdentifier.lowercased()
                if id == IAPProduct.monthly.rawValue.lowercased() { map[.monthly] = pkg.storeProduct }
                if id == IAPProduct.weekly.rawValue.lowercased()  { map[.weekly]  = pkg.storeProduct }
            }
            self.rcMap = map
            self.rcProducts = Array(map.values)
            self.rcReady = !map.isEmpty
        }
    }

    @MainActor
    func purchaseApple(product: StoreProduct, onFinished: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        Purchases.shared.purchase(product: product) { [weak self] _, customerInfo, error, _ in
            guard let self else { return }
            self.isLoading = false
            if let error = error { onFinished(.failure(error)); return }

            let active = !(customerInfo?.activeSubscriptions.isEmpty ?? true)
            self.appleEntitled = active
            self.isSubscriptionActive = active
            if active { self.provider = .apple }

            if active {
                Task { @MainActor in
                    await self.ensureAppleDocInFirestore()
                    onFinished(.success(()))
                }
            } else {
                onFinished(.failure(NSError(domain: "iap", code: -4,
                                            userInfo: [NSLocalizedDescriptionKey: "Purchase not active"])))
            }
        }
    }

    func restoreApplePurchases(completion: @escaping (Bool) -> Void) {
        Purchases.shared.restorePurchases { [weak self] info, _ in
            guard let self else { return }
            let active = !(info?.activeSubscriptions.isEmpty ?? true)
            self.appleEntitled = active
            self.isSubscriptionActive = self.isSubscriptionActive || active
            if active {
                self.provider = .apple
                Task { @MainActor in
                    await self.ensureAppleDocInFirestore()
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

    func refreshAppleEntitlementAtLaunch() async {
        let active = await hasActiveAppleAutoRenewable()
        appleEntitled = active
        if active {
            isSubscriptionActive = true
            provider = .apple
            await ensureAppleDocInFirestore()
        }
        UserDefaults.standard.set(active, forKey: wasAppleActiveKey)
    }

    private func hasActiveAppleAutoRenewable() async -> Bool {
        guard #available(iOS 15.0, *) else { return false }
        do {
            for await entitlement in Transaction.currentEntitlements {
                if case .verified(let tx) = entitlement, tx.productType == .autoRenewable {
                    let notRevoked = tx.revocationDate == nil
                    let notExpired = tx.expirationDate.map { $0 > Date() } ?? true
                    if notRevoked && notExpired { return true }
                }
            }
        } catch { }
        return false
    }

    @MainActor
    private func ensureAppleDocInFirestore() async {
        guard let uid = Auth.auth().currentUser?.uid
              ?? UserDefaultsHelper.getData(type: String.self, forKey: .userId) else { return }
        let ref = Firestore.firestore().collection(subscriptionDoc).document(uid)
        let data: [String: Any] = [
            "provider": "apple",
            "active": true,
            "status": "active",
            "updatedAt": FieldValue.serverTimestamp()
        ]
        do { try await ref.setData(data, merge: true) } catch { }
    }

    // MARK: - Stripe (Apple Pay only) – 24.23.x

    func startApplePayPurchase(
        for plan: IAPProduct,
        from presentingVC: UIViewController,
        onFinished: @escaping (Result<Void, Error>) -> Void
    ) {
        guard !isLoading else {
            onFinished(.failure(NSError(domain: "stripe", code: -100,
                                        userInfo: [NSLocalizedDescriptionKey: "Busy"])))
            return
        }
        isLoading = true

        ensureSignedIn { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure(let err):
                self.isLoading = false
                onFinished(.failure(err))

            case .success:
                let payload = ["plan": plan.rawValue]
                self.fx.httpsCallable("createSubscriptionApplePay").call(payload) { res, err in
                    if let err = err {
                        self.isLoading = false
                        onFinished(.failure(err)); return
                    }

                    guard
                        let dict = res?.data as? [String: Any],
                        let clientSecret   = dict["paymentIntentClientSecret"] as? String,
                        let amountMinor    = dict["amount"] as? Int,
                        let currencyRaw    = dict["currency"] as? String,
                        let label          = dict["label"] as? String,
                        let subscriptionId = dict["subscriptionId"] as? String
                    else {
                        self.isLoading = false
                        onFinished(.failure(NSError(domain: "stripe", code: -1,
                                                    userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                        return
                    }

                    let request = StripeAPI.paymentRequest(
                        withMerchantIdentifier: self.applePayMerchantId,
                        country: self.merchantCountryCode,
                        currency: currencyRaw.uppercased()
                    )

                    let major = NSDecimalNumber(value: amountMinor)
                        .dividing(by: NSDecimalNumber(value: 100))
                    request.paymentSummaryItems = [ PKPaymentSummaryItem(label: label, amount: major) ]
                    request.merchantCapabilities = [.capability3DS]
                    request.supportedNetworks = [.visa, .masterCard, .amex, .discover]

                    guard PKPaymentAuthorizationController.canMakePayments(),
                          PKPaymentAuthorizationController
                            .canMakePayments(usingNetworks: request.supportedNetworks) else {
                        self.isLoading = false
                        onFinished(.failure(NSError(domain: "stripe", code: -2,
                                                    userInfo: [NSLocalizedDescriptionKey:
                                                               "Apple Pay unavailable on this device/account."])))
                        return
                    }

                    // Stash state for the delegate
                    self.pendingClientSecret = clientSecret
                    self.pendingSubscriptionId = subscriptionId
                    self.pendingAfterFinish = { [weak self] result in
                        self?.isLoading = false
                        onFinished(result)
                    }
                    self.pendingFinalize = { [weak self] subId, completion in
                        guard let self else { return }
                        self.fx.httpsCallable("finalizeSubscription").call(["subscriptionId": subId]) { res, err in
                            if let err = err { completion(.failure(err)); return }
                            guard let dict = res?.data as? [String: Any],
                                  let ok = dict["finalized"] as? Bool, ok == true else {
                                completion(.failure(NSError(domain: "stripe", code: -10,
                                                            userInfo: [NSLocalizedDescriptionKey: "Not active yet"])))
                                return
                            }
                            DispatchQueue.main.async {
                                self.isSubscriptionActive = true
                                self.provider = .stripe
                            }
                            completion(.success(()))
                        }
                    }

                    // Create & present Apple Pay
                    guard let context = STPApplePayContext(paymentRequest: request, delegate: self) else {
                        self.isLoading = false
                        onFinished(.failure(NSError(domain: "stripe", code: -5,
                                                    userInfo: [NSLocalizedDescriptionKey:
                                                               "Failed to create Apple Pay context."])))
                        return
                    }
                    self.applePayContext = context
                    context.presentApplePay()
                }
            }
        }
    }

    // MARK: - Cancel at period end

    func cancelStripeSubscription(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isCancelling else { return }
        isCancelling = true
        isLoading = true
        ensureSignedIn { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let e):
                self.isCancelling = false
                self.isLoading = false
                completion(.failure(e))
            case .success:
                self.fx.httpsCallable("cancelSubscription").call { _, err in
                    self.isCancelling = false
                    self.isLoading = false
                    if let err = err { completion(.failure(err)) }
                    else {
                        self.isSubscriptionActive = false
                        self.provider = .none
                        completion(.success(()))
                    }
                }
            }
        }
    }

    // MARK: - Tokens & helpers

    func canAccessFeature() -> Bool {
        if isSubscriptionActive { return true }
        if totalDiamonds >= 1 { totalDiamonds -= 1; updateDiamondsCount(); return true }
        return false
    }

    func islimitReached() -> Bool { totaltokenUsage < 10000 }
    func isSubscriptionOnlyFeatureAccessible() -> Bool { isSubscriptionActive }

    private func updateDiamondsCount() {
        guard let uid = currentUid else { return }
        UserFirebaseHelper.shared.update(userId: uid, fields: ["diamonds": totalDiamonds]) { _ in }
    }

    func updatetokenusageCount() {
        guard let uid = currentUid else { return }
        UserFirebaseHelper.shared.update(userId: uid, fields: ["tokenUsage": totaltokenUsage]) { _ in }
    }

    func checkAndResetTokensIfNeeded() {
        let last = UserDefaultsHelper.getData(type: Date.self, forKey: .lastTokenResetDate) ?? .distantPast
        let today = Calendar.current.startOfDay(for: Date())
        if today > Calendar.current.startOfDay(for: last) {
            tokensLeft = 10000
            resetTokenUsageCount()
            UserDefaultsHelper.setData(value: today, key: .lastTokenResetDate)
        }
    }

    func resetTokenUsageCount() {
        totaltokenUsage = 0
        guard let uid = currentUid else { return }
        UserFirebaseHelper.shared.update(userId: uid, fields: ["tokenUsage": 0]) { _ in }
    }

    // MARK: - Helpers

    private var currentUid: String? {
        Auth.auth().currentUser?.uid ?? UserDefaultsHelper.getData(type: String.self, forKey: .userId)
    }

    private func ensureSignedIn(_ completion: @escaping (Result<Void, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            user.getIDTokenResult(forcingRefresh: true) { result, error in
                if let _ = error { self.performAnonymousSignIn(completion) }
                else if let token = result?.token, !token.isEmpty { completion(.success(())) }
                else { self.performAnonymousSignIn(completion) }
            }
            return
        }
        performAnonymousSignIn(completion)
    }

    private func performAnonymousSignIn(_ completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signInAnonymously { result, error in
            if let error = error { completion(.failure(error)); return }
            result?.user.getIDToken { token, err in
                if let err = err { completion(.failure(err)) }
                else if token != nil { completion(.success(())) }
                else {
                    completion(.failure(NSError(domain: "auth", code: -2,
                                                userInfo: [NSLocalizedDescriptionKey: "No token"])))
                }
            }
        }
    }
}

// MARK: - Stripe Apple Pay Context Delegate (Stripe 24.x)
extension SubscriptionManager: STPApplePayContextDelegate {
    func applePayContext(_ context: STPApplePayContext,
                         didCreatePaymentMethod paymentMethod: STPPaymentMethod,
                         paymentInformation: PKPayment,
                         completion: @escaping (String?, (any Error)?) -> Void) {
        completion(pendingClientSecret, nil)
    }

    func applePayContext(_ context: STPApplePayContext,
                         didCompleteWith status: STPApplePayContext.PaymentStatus,
                         error: (any Error)?) {
        let afterFinish = pendingAfterFinish
        let finalize = pendingFinalize
        let subId = pendingSubscriptionId

        // Clear state
        pendingClientSecret = nil
        pendingSubscriptionId = nil
        pendingAfterFinish = nil
        pendingFinalize = nil
        applePayContext = nil

        switch status {
        case .success:
            if let subId, let finalize {
                finalize(subId) { result in
                    afterFinish?(result)
                }
            } else {
                afterFinish?(.failure(NSError(domain: "stripe", code: -9,
                                              userInfo: [NSLocalizedDescriptionKey: "Missing finalize/subscriptionId"])))
            }
        case .error:
            afterFinish?(.failure(error ?? NSError(domain: "stripe", code: -3,
                                                   userInfo: [NSLocalizedDescriptionKey: "Apple Pay error"])))
        case .userCancellation:
            afterFinish?(.failure(NSError(domain: "stripe", code: 1,
                                          userInfo: [NSLocalizedDescriptionKey: "User canceled"])))
        @unknown default:
            afterFinish?(.failure(NSError(domain: "stripe", code: -4,
                                          userInfo: [NSLocalizedDescriptionKey: "Unknown Apple Pay result"])))
        }
    }
}

// MARK: - Helper classes (to be implemented separately)
// These are referenced in the code but need to be implemented

class UserDefaultsHelper {
    enum Key {
        case userId
        case lastTokenResetDate
    }
    
    static func getData<T>(type: T.Type, forKey key: Key) -> T? {
        let keyString = keyToString(key)
        return UserDefaults.standard.object(forKey: keyString) as? T
    }
    
    static func setData<T>(value: T, key: Key) {
        let keyString = keyToString(key)
        UserDefaults.standard.set(value, forKey: keyString)
    }
    
    private static func keyToString(_ key: Key) -> String {
        switch key {
        case .userId: return "userId"
        case .lastTokenResetDate: return "lastTokenResetDate"
        }
    }
}

class UserFirebaseHelper {
    static let shared = UserFirebaseHelper()
    
    func update(userId: String, fields: [String: Any], completion: @escaping (Error?) -> Void) {
        let ref = Firestore.firestore().collection("users").document(userId)
        ref.updateData(fields) { error in
            completion(error)
        }
    }
}