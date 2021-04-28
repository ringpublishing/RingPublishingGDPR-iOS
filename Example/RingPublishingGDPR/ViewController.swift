//
//  ViewController.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 10/12/2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import UIKit
import RingPublishingGDPR

/// Demo controller for RingPublishingGDPR module
class ViewController: UIViewController {

    // MARK: Helper methods

    func showRingPublishingGDPRController(openScreen: ConsentsFormScreen) {
        // Here you can get UIViewController to present from module:
        let consentController = RingPublishingGDPR.shared.ringPublishingGDPRViewController

        // Present controller
        present(consentController, animated: true, completion: nil)

        // Tell to the controller which view you want to show at start
        switch openScreen {
        case .welcome:
            // To be opened on fresh app or when list of vendors has changed
            consentController.showConsentsWelcomeScreen()
        case .settings:
            // To be opened from application settings
            consentController.showConsentsSettingsScreen()
        }
    }

    // MARK: Actions

    @IBAction func onShowRingPublishingGDPRWelcomeTouch(_ sender: Any) {
        showRingPublishingGDPRController(openScreen: .welcome)
    }

    @IBAction func onShowRingPublishingGDPRDetailTouch(_ sender: Any) {
        showRingPublishingGDPRController(openScreen: .settings)
    }
}
