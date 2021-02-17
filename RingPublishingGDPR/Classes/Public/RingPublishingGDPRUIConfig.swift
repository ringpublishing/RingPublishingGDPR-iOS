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

    /// Theme color used for loading indicator and actions buttons (in error view & App Tracking Transparency explanation screens)
    @objc public let themeColor: UIColor

    /// Color used for action button texts (in error view & App Tracking Transparency explanation screens)
    @objc public let buttonTextColor: UIColor

    /// Font used in error view & App Tracking Transparency explanation screens
    @objc public let font: UIFont

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter themeColor: Theme color used for loading indicator and retry button color
    /// - Parameter buttonTextColor: Color used for text on action buttons
    /// - Parameter font: Font used in native views
    @objc
    public init(themeColor: UIColor, buttonTextColor: UIColor, font: UIFont) {
        self.themeColor = themeColor
        self.buttonTextColor = buttonTextColor
        self.font = font
    }
}
