//
//  RingPublishingGDPRATTConfig.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 16/02/2021.
//

import Foundation
import UIKit

/// RingPublishingGDPR module configuration used for App Tracking Transparency explanation screen & Apple ATT
public class RingPublishingGDPRATTConfig: NSObject {

    /// Should Apple App Tracking Transparency permission alert be shown after GDPR consents screen?
    ///
    /// If this option is enabled, texts for explanation (screen before apple alert is shown) should be provided
    @objc public let appTrackingTransparencySupportEnabled: Bool

    /// Brand logo image which can be shown on App Tracking Transparency explanation screens
    @objc public var brandLogoImage: UIImage?

    /// Text which will be displayed as title for App Tracking Transparency explanation screen
    ///
    /// This can be plain text or text with HTML attributes.
    @objc public var explanationTitle: String?

    /// Text which will be displayed as description for App Tracking Transparency explanation screen
    ///
    /// This can be plain text or text with HTML attributes.
    @objc public var explanationDescription: String?

    /// Text which will be displayed as "cancel" / "not now" button for App Tracking Transparency explanation screen
    /// If nil is passed or value is not set, this button will be hidden in UI
    @objc public var explanationNotNowButtonText: String?

    /// Text which will be displayed as "allow" / "continue" button for App Tracking Transparency explanation screen
    @objc public var explanationAllowButtonText: String?

    // MARK: Init

    /// Initializer
    /// 
    /// - Parameter appTrackingTransparencySupportEnabled: Should Apple App Tracking Transparency permission alert
    ///     be shown after GDPR consents screen?
    @objc
    public init(appTrackingTransparencySupportEnabled: Bool) {
        self.appTrackingTransparencySupportEnabled = appTrackingTransparencySupportEnabled
    }
}
