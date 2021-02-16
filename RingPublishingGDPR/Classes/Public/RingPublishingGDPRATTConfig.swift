//
//  RingPublishingGDPRATTConfig.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 16/02/2021.
//

import Foundation
import UIKit

/// RingPublishingGDPR module configuration used for App Tracking Transparency explaination screen & Apple ATT
public class RingPublishingGDPRATTConfig: NSObject {

    /// Should Apple App Tracking Transparency permission alert be shown after GDPR consents screen?
    ///
    /// If this option is enabled, texts for explaination (screen before apple alert is shown) should be provided
    /// inside 'RingPublishingGDPRUIConfig'
    @objc public let appTrackingTransparencySupportEnabled: Bool

    /// Brand logo image which can be shown on App Tracking Transparency explaination screens
    @objc public var brandLogoImage: UIImage?

    /// Text which will be displayed as title for App Tracking Transparency explaination screen
    ///
    /// This can be plain text or text with HTML attributes.
    @objc public var attExplainationTitle: String?

    /// Text which will be displayed as description for App Tracking Transparency explaination screen
    ///
    /// This can be plain text or text with HTML attributes.
    @objc public var attExplainationDescription: String?

    /// Text which will be displayed as "cancel" / "not now" button for App Tracking Transparency explaination screen
    @objc public var attExplainationNotNowButtonText: String?

    /// Text which will be displayed as "allow" / "continue" button for App Tracking Transparency explaination screen
    @objc public var attExplainationAllowButtonText: String?

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
