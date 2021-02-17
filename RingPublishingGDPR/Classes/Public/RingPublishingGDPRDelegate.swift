//
//  RingPublishingGDPRDelegate.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit

/// RingPublishingGDPR module delegate
@objc
public protocol RingPublishingGDPRDelegate: class {

    // MARK: Required methods

    /// Delegate method saying that application should show again consents form
    ///
    /// - Parameters:
    ///   - ringPublishingGDPR: RingPublishingGDPR
    ///   - viewController: RingPublishingGDPRViewController
    @objc
    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            shouldShowConsentsController viewController: RingPublishingGDPRViewController)

    /// Delegate method saying that application should close consents form and apply selected consents by the user
    ///
    /// - Parameters:
    ///   - ringPublishingGDPR: RingPublishingGDPR
    ///   - viewController: RingPublishingGDPRViewController
    @objc
    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            shouldHideConsentsController viewController: RingPublishingGDPRViewController)

    // MARK: Optional methods

    /// Delegate method saying that application should open url selected by the user
    ///
    /// - Parameters:
    ///   - ringPublishingGDPR: RingPublishingGDPR
    ///   - url: URL
    @objc optional
    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, didRequestToOpenUrl url: URL)

    /// Delegate method saying that App Tracking Transparency explanation screen was presented to the user
    ///
    /// - Parameter ringPublishingGDPR: RingPublishingGDPR
    @objc optional
    func ringPublishingGDPRDidPresentATTExplanationScreen(_ ringPublishingGDPR: RingPublishingGDPR)

    /// Delegate method saying that  user selected one of the ATT explanation options
    ///
    /// - Parameters:
    ///   - ringPublishingGDPR: RingPublishingGDPR
    ///   - allow: Bool
    @objc optional
    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, userSelectedATTExplanationOptionAllowingTracking allow: Bool)

    /// Delegate method saying that  user selected one of the ATT system alert permission options
    ///
    /// - Parameters:
    ///   - ringPublishingGDPR: RingPublishingGDPR
    ///   - allow: Bool
    @objc optional
    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, userSelectedATTAlertPermisionAllowingTracking allow: Bool)
}
