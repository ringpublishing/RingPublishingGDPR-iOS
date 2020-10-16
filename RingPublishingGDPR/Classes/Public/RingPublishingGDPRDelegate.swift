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

    /// Delegate method saying that application should show again consents form
    ///
    /// - Parameters:
    ///   - ringPublishingGDPR: RingPublishingGDPR
    ///   - viewController: RingPublishingGDPRViewController
    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            shouldShowConsentsController viewController: RingPublishingGDPRViewController)

    /// Delegate method saying that application should close consents form and apply selected consents by the user
    ///
    /// - Parameters:
    ///   - ringPublishingGDPR: RingPublishingGDPR
    ///   - viewController: RingPublishingGDPRViewController
    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            shouldHideConsentsController viewController: RingPublishingGDPRViewController)
}
