//
//  LoadingView.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit

/// Loading view with animated element
class LoadingView: UIView {

    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: Life cycle

    override func removeFromSuperview() {
        super.removeFromSuperview()

        stopAnimation()
    }

    // MARK: Set up

    /// Configure loading view with theme color
    ///
    /// - Parameters:
    ///   - uiConfig: RingPublishingGDPRUIConfig
    func configure(with uiConfig: RingPublishingGDPRUIConfig?) {
        loadingIndicator.color = uiConfig?.themeColor
    }

    // MARK: Animation

    /// Start animation in view
    func startAnimation() {
        loadingIndicator.startAnimating()
    }

    /// Stop animation in view
    func stopAnimation() {
        loadingIndicator.stopAnimating()
    }
}
