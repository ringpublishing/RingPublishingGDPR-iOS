//
//  RingPublishingGDPR.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// Main class for RingPublishingGDPR module
public class RingPublishingGDPR: NSObject {

    // MARK: Public properties

    /// Shared instance
    @objc public static let shared = RingPublishingGDPR()

    /// View controller which should be presented by application to the users
    ///
    /// Contains consents form & loading view
    @objc public let ringPublishingGDPRViewController: RingPublishingGDPRViewController

    /// Closure which can be used to gather module logs inside host application
    ///
    /// Module is using os_log to report what is happening - but if this is not enough you can get all logged messages using this closure
    /// For os_log there is defined:
    /// - subsystem: Bundle.main.bundleIdentifier
    /// - category: RingPublishingGDPR
    @objc public var loggerOutput: ((_ message: String) -> Void)? {
        get {
            return Logger.shared.loggerOutput
        }
        set {
            Logger.shared.loggerOutput = newValue
        }
    }

    /// Web view & API timeout (in seconds)
    ///
    /// Default value is 10s
    /// If you want to change this - set this value before module initialization
    @objc public var networkingTimeout: TimeInterval = 10 {
        didSet {
            manager?.timeoutInterval = networkingTimeout
        }
    }

    /// Returns boolean value which determines whether consent for vendors and theirs purposes for processing data was established
    @objc public var areVendorConsentsGiven: Bool {
        return GDPRStorage.ringPublishingVendorsConsent == 1
    }

    /// Allows you to clear all stored consent data in UserDefaults prefixed with IABTCF_ && RingPublishing_
    @objc
    public func clearConsentsData() {
        GDPRStorage.clearAllConsentData()
    }

    // MARK: Private properties

    /// Module delegate
    private weak var delegate: RingPublishingGDPRDelegate?

    /// Manager which handles internal module logic
    private var manager: GDPRManager?

    // MARK: Init

    /// Initializer
    private override init() {
        self.ringPublishingGDPRViewController = RingPublishingGDPRViewController.loadFromNib(bundle: Bundle.ringPublishingGDPRBundle)

        super.init()
    }
}

// MARK: Public interface

public extension RingPublishingGDPR {

    /// Configure RingPublishingGDPR module
    ///
    /// If you want to ignore geo-ip detection for 'gdprApplies', pass as 'forcedGDPRApplies' param either true of false.
    /// Passing nil leaves default behaviour intact.
    ///
    /// - Parameter config: Module config
    /// - Parameter delegate: RingPublishingGDPRDelegate
    /// - Parameter forcedGDPRApplies: NSNumber?
    @objc
    func initialize(config: RingPublishingGDPRConfig, delegate: RingPublishingGDPRDelegate, forcedGDPRApplies: NSNumber? = nil) {
        self.delegate = delegate
        self.manager = GDPRManager(config: config,
                                   delegate: self,
                                   timeoutInterval: networkingTimeout,
                                   forcedGDPRApplies: forcedGDPRApplies as? Bool)

        // Configure ringPublishingGDPR view controller
        ringPublishingGDPRViewController.configure(with: config.uiConfig, attConfig: config.attConfig)
        ringPublishingGDPRViewController.setInternalDelegate(manager)

        // Fetch required configuration & determine if consents form should be shown
        manager?.determineConsentsStatusOnStartup()
    }
}

// MARK: RingPublishingGDPRManagerDelegate

extension RingPublishingGDPR: GDPRManagerDelegate {

    func gdprManagerDidDetermineThatConsentsAreUpToDate(_ manager: GDPRManager) {
        delegate?.ringPublishingGDPRDoesNotNeedToUpdateConsents(self)
    }

    func gdprManagerDidRequestToShowConsentsController(_ manager: GDPRManager) {
        delegate?.ringPublishingGDPR(self, shouldShowConsentsController: ringPublishingGDPRViewController)
    }

    func gdrpManagerDidRequestToHideConsentsController(_ manager: GDPRManager) {
        delegate?.ringPublishingGDPR(self, shouldHideConsentsController: ringPublishingGDPRViewController)
    }

    func gdprManager(_ manager: GDPRManager, isRequestingToChangeViewState state: ViewState) {
        ringPublishingGDPRViewController.show(state: state)

        guard state == .appTrackingTransparency else { return }

        delegate?.ringPublishingGDPRDidPresentATTExplanationScreen?(self)
    }

    func gdprManager(_ manager: GDPRManager, isRequestingToEmbedWebView webView: WKWebView) {
        ringPublishingGDPRViewController.configure(with: webView)
    }

    func gdprManager(_ manager: GDPRManager, isRequestingToOpenUrl url: URL) {
        delegate?.ringPublishingGDPR?(self, didRequestToOpenUrl: url)
    }

    func gdprManager(_ manager: GDPRManager, userSelectedATTExplanationOptionWithResult trackingAllowed: Bool) {
        delegate?.ringPublishingGDPR?(self, userSelectedATTExplanationOptionWithResult: trackingAllowed)
    }

    func gdprManager(_ manager: GDPRManager, userSelectedATTAlertPermissionWithResult trackingAllowed: Bool) {
        delegate?.ringPublishingGDPR?(self, userSelectedATTAlertPermissionWithResult: trackingAllowed)
    }
}
