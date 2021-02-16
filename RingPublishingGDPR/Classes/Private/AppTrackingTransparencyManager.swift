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

    @ConsentStorage(key: "RingPublishing_AppTrackingTransparencyExplainationShown", logableAsConsent: false)
    private var appTrackingTransparencyExplainationShown: Bool?

    /// Is support for App Tracking Transparency enabled?
    private let appTrackingTransparencySupportEnabled: Bool

    /// Returns true if tracking status is determined & we do not have to ask for permissions
    var trackingStatusDetermined: Bool {
        guard #available(iOS 14, *), appTrackingTransparencySupportEnabled else {
            // If we can't show permission question, assume status is determined
            return true
        }

        let explainationShown = appTrackingTransparencyExplainationShown ?? false
        let attStatusDetermined = ATTrackingManager.trackingAuthorizationStatus != .notDetermined

        return explainationShown || attStatusDetermined
    }

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter appTrackingTransparencySupportEnabled: Is support for App Tracking Transparency enabled?
    init(appTrackingTransparencySupportEnabled: Bool) {
        self.appTrackingTransparencySupportEnabled = appTrackingTransparencySupportEnabled
    }

    // MARK: Methods

    /// Store info that explaination for App Tracking Transparency was shown to the user
    func markExplainationAsShown() {
        appTrackingTransparencyExplainationShown = true
    }

    /// Showsr App Tracking Transparency alert
    ///
    /// - Parameter completion: Completion handler
    func showAppTrackingTransparencyAlert(completion: @escaping (_ trackingAllowed: Bool) -> Void) {
        guard #available(iOS 14, *), appTrackingTransparencySupportEnabled else {
            // This should never happen
            Logger.log("Requests to show AppTrackingTransparency alert was performed below iOS 14!", level: .error)
            completion(false)
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

            let trackingAllowed = status == .authorized

            DispatchQueue.main.async {
                completion(trackingAllowed)
            }
        }
    }
}
