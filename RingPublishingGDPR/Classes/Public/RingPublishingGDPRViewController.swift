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
        let loadingView: LoadingView = LoadingView.loadFromNib(bundle: Bundle.ringPublishingGDPRBundle)
        loadingView.configure(with: uiConfig)

        return loadingView
    }()

    /// Error view
    private lazy var errorView: ErrorView = {
        let errorView: ErrorView = ErrorView.loadFromNib(bundle: Bundle.ringPublishingGDPRBundle)
        errorView.delegate = delegate
        errorView.configure(with: uiConfig)

        return errorView
    }()

    /// App Tracking Transparency View
    private lazy var appTrackingTransparencyView: AppTrackingTransparencyView = {
        let attView: AppTrackingTransparencyView = AppTrackingTransparencyView.loadFromNib(bundle: Bundle.ringPublishingGDPRBundle)
        attView.delegate = delegate
        attView.configure(with: uiConfig, attConfig: attConfig)

        return attView
    }()

    /// Current state
    private var state: ViewState = .gdprConsents

    /// Currently shown state view
    private weak var currentlyShownStateView: UIView?

    /// Internal module delegate
    private weak var delegate: RingPublishingGDPRViewControllerDelegate?

    /// Module UI config
    private var uiConfig: RingPublishingGDPRUIConfig?

    /// Module ATT config
    private var attConfig: RingPublishingGDPRATTConfig?
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
    }

    /// Configure internal views using RingPublishingGDPRUIConfig
    ///
    /// - Parameters:
    ///   - uiConfig: RingPublishingGDPRUIConfig
    ///   - attConfig: RingPublishingGDPRATTConfig
    func configure(with uiConfig: RingPublishingGDPRUIConfig, attConfig: RingPublishingGDPRATTConfig?) {
        self.uiConfig = uiConfig
        self.attConfig = attConfig
    }
}
