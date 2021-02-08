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

    /// Returns true if tracking status is determined & we do not have to ask for permissions
    var trackingStatusDetermined: Bool {
        guard #available(iOS 14, *) else {
            // If we can't show permission question, assume status is determined
            return true
        }

        return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
    }


}
