//
//  RingPublishingGDPRATTConfig+ContentAlignment.swift
//  RingPublishingGDPR
//

import Foundation

public extension RingPublishingGDPRATTConfig {

    /// Layout of the content (logo and texts) on the App Tracking Transparency explanation screen.
    enum ContentAlignment {

        /// Logo and texts are aligned to the leading edge. This is the default layout.
        case topLeft

        /// Logo and texts are centered horizontally.
        case center
    }
}
