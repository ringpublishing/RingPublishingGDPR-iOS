//
//  AppTrackingTransparencyView.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 08/02/2021.
//

import Foundation
import UIKit

/// "Onboarding" view for App Tracking Transparency
class AppTrackingTransparencyView: UIView {

    @IBOutlet private weak var actionButton: UIButton!

    /// Proxy for parent view delegate
    weak var delegate: RingPublishingGDPRViewControllerDelegate?

    // MARK: Set up

    



}

// MARK: Private
private extension AppTrackingTransparencyView {

    @IBAction func onActionButtonTouch(_ sender: Any) {
        delegate?.ringPublishingGDPRViewControllerDidRequestToShowAppTrackingTransparency()
    }
}
