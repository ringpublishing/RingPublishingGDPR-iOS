//
//  RingPublishingGDPRFormView.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// View presenting loading, error and consents form
public class RingPublishingGDPRViewController: UIViewController {

    /// Loading view
    private lazy var loadingView: LoadingView = {
        return LoadingView.loadFromNib(bundle: Bundle.ringPublishingGDPRBundle)
    }()

    /// Error view
    private lazy var errorView: ErrorView = {
        return ErrorView.loadFromNib(bundle: Bundle.ringPublishingGDPRBundle)
    }()

    /// App Tracking Transparency View
    private lazy var appTrackingTransparencyView: AppTrackingTransparencyView = {
        return AppTrackingTransparencyView.loadFromNib(bundle: Bundle.ringPublishingGDPRBundle)
    }()

    /// Current state
    private var state: ViewState = .gdprConsents

    /// Currently shown state view
    private weak var currentlyShownStateView: UIView?

    /// Internal module delegate
    private weak var delegate: RingPublishingGDPRViewControllerDelegate?
}

// MARK: Public interface

public extension RingPublishingGDPRViewController {

    /// Show consents welcome screen
    @objc
    func showConsentsWelcomeScreen() {
        delegate?.ringPublishingGDPRViewControllerDidRequestToShowWelcomeScreen()
    }

    /// Show consents settings screen
    @objc
    func showConsentsSettingsScreen() {
        delegate?.ringPublishingGDPRViewControllerDidRequestToShowSetingsScreen()
    }
}

// MARK: Internal

extension RingPublishingGDPRViewController {

    // MARK: State

    func show(state: ViewState) {
        currentlyShownStateView?.removeFromSuperview()
        self.state = state

        switch state {
        case .gdprConsents:
            currentlyShownStateView = nil

        case .appTrackingTransparency:
            view.addSubviewFullscreen(appTrackingTransparencyView)
            currentlyShownStateView = appTrackingTransparencyView

        case .loading:
            loadingView.startAnimation()
            view.addSubviewFullscreen(loadingView)
            currentlyShownStateView = loadingView

        case .error:
            view.addSubviewFullscreen(errorView)
            currentlyShownStateView = errorView
        }
    }

    // MARK: Configuration

    /// Add WKWebView to view hierarchy
    ///
    /// - Parameters:
    ///   - webView: WKWebView
    func configure(with webView: WKWebView) {
        view.addSubviewFullscreen(webView, at: 0)
    }

    /// Sets internal delegate for ringPublishingGDPRview
    ///
    /// - Parameter delegate: RingPublishingGDPRViewControllerDelegate
    func setInternalDelegate(_ delegate: RingPublishingGDPRViewControllerDelegate?) {
        self.delegate = delegate

        errorView.delegate = delegate
        appTrackingTransparencyView.delegate = delegate
    }

    /// Configure internal views using RingPublishingGDPRUIConfig
    ///
    /// - Parameters:
    ///   - uiConfig: RingPublishingGDPRUIConfig
    ///   - attConfig: RingPublishingGDPRATTConfig
    func configure(with uiConfig: RingPublishingGDPRUIConfig, attConfig: RingPublishingGDPRATTConfig?) {
        loadingView.configure(with: uiConfig)
        errorView.configure(with: uiConfig)
        appTrackingTransparencyView.configure(with: uiConfig, attConfig: attConfig)
    }
}
