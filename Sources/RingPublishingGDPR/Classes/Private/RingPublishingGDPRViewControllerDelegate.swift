//
//  RingPublishingGDPRViewControllerDelegate.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit

/// Internal protocol used to communicate between RingPublishingGDPR module and ViewController
protocol RingPublishingGDPRViewControllerDelegate: AnyObject {

    /// View controller wants to show CMP welcome screen
    func ringPublishingGDPRViewControllerDidRequestToShowWelcomeScreen()

    /// View controller wants to show CMP settings screen
    func ringPublishingGDPRViewControllerDidRequestToShowSetingsScreen()

    /// View controller wants to reload CMP site
    func ringPublishingGDPRViewControllerDidRequestReload()

    /// View controller informs that user did not want to answer ATT permission question
    func ringPublishingGDPRViewControllerDidDismissAppTrackingTransparencyExplanation()

    /// View controller wants to show App Tracking Transparency alert
    func ringPublishingGDPRViewControllerDidRequestToShowAppTrackingTransparency()

    /// View controller wants to open url selected from text
    func ringPublishingGDPRViewControllerDidRequestToOpenURL(_ url: URL)
}
