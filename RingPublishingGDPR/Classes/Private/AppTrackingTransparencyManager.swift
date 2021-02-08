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

    /// Is support for App Tracking Transparency enabled?
    private let supportsAppTrackingTransparency: Bool

    /// Returns true if tracking status is determined & we do not have to ask for permissions
    var trackingStatusDetermined: Bool {
        guard #available(iOS 14, *), supportsAppTrackingTransparency else {
            // If we can't show permission question, assume status is determined
            return true
        }

        return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
    }

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter supportsAppTrackingTransparency: Is support for App Tracking Transparency enabled?
    init(supportsAppTrackingTransparency: Bool) {
        self.supportsAppTrackingTransparency = supportsAppTrackingTransparency
    }

    // MARK: Methods

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
