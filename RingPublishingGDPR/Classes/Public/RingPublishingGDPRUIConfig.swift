//
//  RingPublishingGDPRUIConfig.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit

/// RingPublishingGDPR module UI configuration
public class RingPublishingGDPRUIConfig: NSObject {

    // MARK: Required config options

    /// Theme color used for loading indicator and actions buttons (in error view & App Tracking Transparency onboarding)
    @objc
    public var themeColor: UIColor

    /// Color used for action button texts (in error view & App Tracking Transparency onboarding)
    @objc
    public var buttonTextColor: UIColor

    /// Font used in error view & App Tracking Transparency onboarding
    @objc
    public var font: UIFont

    // MARK: Optional config options

    /// Brand logo image which can be shown on App Tracking Transparency onboarding
    @objc
    public var brandLogoImage: UIImage?

    /// Text which will be displayed as title for App Tracking Transparency onboarding
    ///
    /// This can be plain text or text with HTML attributes.
    @objc
    public var attOnboardingTitle: String?

    /// Text which will be displayed as description for App Tracking Transparency onboarding
    ///
    /// This can be plain text or text with HTML attributes.
    @objc
    public var attOnboardingDescription: String?

    /// Text which will be displayed as "cancel" / "not now" button for App Tracking Transparency onboarding
    @objc
    public var attOnboardingCancelButtonText: String?

    /// Text which will be displayed as "allow" / "continue" button for App Tracking Transparency onboarding
    @objc
    public var attOnboardingAllowButtonText: String?

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter themeColor: Theme color used for loading indicator and retry button color
    /// - Parameter buttonTextColor: Theme color used for loading indicator and retry button color
    /// - Parameter font: Font used in error view
    @objc
    public init(themeColor: UIColor, buttonTextColor: UIColor, font: UIFont) {
        self.themeColor = themeColor
        self.buttonTextColor = buttonTextColor
        self.font = font
    }
}
