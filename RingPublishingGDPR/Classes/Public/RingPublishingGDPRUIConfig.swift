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

    /// Theme color used for loading indicator and retry button color
    @objc
    public let themeColor: UIColor

    /// Color used for retry button text
    @objc
    public let buttonTextColor: UIColor

    /// Font used in error view
    @objc
    public let font: UIFont

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
