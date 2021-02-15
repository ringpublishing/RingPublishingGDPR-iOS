//
//  AppTrackingTransparencyManager.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 08/02/2021.
//

import Foundation
import AppTrackingTransparency

/// Class handling logic related to Apple AppTrackingTransparency
class AppTrackingTransparencyManager {

    @ConsentStorage(key: "RingPublishing_AppTrackingTransparencyOnboardingShown", logableAsConsent: false)
    private var appTrackingTransparencyOnboardingShown: Bool?

    /// Is support for App Tracking Transparency enabled?
    private let supportsAppTrackingTransparency: Bool

    /// Returns true if tracking status is determined & we do not have to ask for permissions
    var trackingStatusDetermined: Bool {
        guard #available(iOS 14, *), supportsAppTrackingTransparency else {
            // If we can't show permission question, assume status is determined
            return true
        }

        let onboardingShown = appTrackingTransparencyOnboardingShown ?? false
        let attStatusDetermined = ATTrackingManager.trackingAuthorizationStatus != .notDetermined

        return onboardingShown || attStatusDetermined
    }

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter supportsAppTrackingTransparency: Is support for App Tracking Transparency enabled?
    init(supportsAppTrackingTransparency: Bool) {
        self.supportsAppTrackingTransparency = supportsAppTrackingTransparency
    }

    // MARK: Methods

    /// Store info stat onboarding for App Tracking Transparency  was shown to the user
    func markOnboardingAsShown() {
        appTrackingTransparencyOnboardingShown = true
    }

    /// Showsr App Tracking Transparency alert
    ///
    /// - Parameter completion: Completion handler
    func showAppTrackingTransparencyAlert(completion: @escaping () -> Void) {
        guard #available(iOS 14, *), supportsAppTrackingTransparency else {
            // This should never happen
            Logger.log("Requests to show AppTrackingTransparency alert was performed below iOS 14!", level: .error)
            completion()
            return
        }

        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                Logger.log("ATTrackingManager returned status: .authorized")
            case .denied:
                Logger.log("ATTrackingManager returned status: .denied")
            case .restricted:
                Logger.log("ATTrackingManager returned status: .restricted")
            case .notDetermined:
                Logger.log("ATTrackingManager returned status: .notDetermined")
            @unknown default:
                Logger.log("ATTrackingManager returned unknown status, rawValue: \(status.rawValue)")
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
