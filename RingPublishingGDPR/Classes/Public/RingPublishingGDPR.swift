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
    @objc
    public static let shared = RingPublishingGDPR()

    /// View controller which should be presented by application to the users
    ///
    /// Contains consents form & loading view
    @objc
    public let ringPublishingGDPRViewController: RingPublishingGDPRViewController

    /// Closure which can be used to gather module logs inside host application
    ///
    /// Module is using os_log to report what is happening - but if this is not enough you can get all logged messages using this closure
    /// For os_log there is defined:
    /// - subsystem: Bundle.main.bundleIdentifier
    /// - category: RingPublishingGDPR
    @objc
    public var loggerOutput: ((_ message: String) -> Void)? {
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
    @objc
    public var networkingTimeout: TimeInterval = 10 {
        didSet {
            manager?.timeoutInterval = networkingTimeout
        }
    }

    /// Check if user should be asked about consents and tcString is NOT stored on the device.
    ///
    /// Returns true if consents are not stored on the device in UserDefaults and GDPR applies
    /// This flag should be only used to check if initial consents are stored.
    /// To know whether or not consents form should be shown again use RingPublishingGDPRDelegate
    @objc
    public var shouldAskUserForConsents: Bool {
        // Nil as true here in case someone uses this property before module initialization
        let gdprApplies = GDPRStorage.gdprApplies == 1 || GDPRStorage.gdprApplies == nil

        return GDPRStorage.tcString == nil && gdprApplies
    }

    /// Allows you to clear all stored consent data in UserDefaults prefixed with IABTCF_ && RingPublishing_
    @objc
    public func clearConsentsData() {
        GDPRStorage.clearAllConsentData()
    }

    /// Returns boolean value which determines whether consent for vendors and theirs purposes for processing data was established
    @objc
    public var areVendorConsentsGiven: Bool {
        return GDPRStorage.ringPublishingVendorsConsent == 1
    }

    /// In addition to standard, SDK stores additional values, which can be used by other Ring Publishing modules, e.g. Ad Server
    @objc
    public var customConsents: [String: Any]? {
        return GDPRStorage.ringPublishingConsents
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
    /// - Parameter tenantId: CMP Tenant Id
    /// - Parameter brandName: App site id used to brand CMP form
    /// - Parameter uiConfig: Module UI config
    /// - Parameter delegate: RingPublishingGDPRDelegate
    /// - Parameter gdprApplies: Does GDPR applies in current context? Defaults to true
    @objc
    func initialize(with tenantId: String,
                    brandName: String,
                    uiConfig: RingPublishingGDPRUIConfig,
                    delegate: RingPublishingGDPRDelegate,
                    gdprApplies: Bool = true) {
        self.delegate = delegate
        self.manager = GDPRManager(tenantId: tenantId, brandName: brandName, delegate: self, timeoutInterval: networkingTimeout)

        manager?.configure(gdprApplies: gdprApplies)

        // Configure ringPublishingGDPR view controller
        ringPublishingGDPRViewController.configure(withThemeColor: uiConfig.themeColor,
                                                   buttonTextColor: uiConfig.buttonTextColor,
                                                   font: uiConfig.font)
        ringPublishingGDPRViewController.setInternalDelegate(manager)

        // Check if app should show again consents form (if form was already displayed once)
        guard GDPRStorage.tcString != nil && gdprApplies else { return }

        manager?.checkUserConsentsStatus()
    }
}

// MARK: RingPublishingGDPRManagerDelegate

extension RingPublishingGDPR: GDPRManagerDelegate {

    func gdprManagerDidRequestToShowConsentsController(_ manager: GDPRManager) {
        delegate?.ringPublishingGDPR(self, shouldShowConsentsController: ringPublishingGDPRViewController)
    }

    func gdrpManagerDidRequestToHideConsentsController(_ manager: GDPRManager) {
        delegate?.ringPublishingGDPR(self, shouldHideConsentsController: ringPublishingGDPRViewController)
    }

    func gdprManager(_ manager: GDPRManager, isRequestingToChangeViewState state: ViewState) {
        ringPublishingGDPRViewController.show(state: state)
    }

    func gdprManager(_ manager: GDPRManager, isRequestingToEmbedWebView webView: WKWebView) {
        ringPublishingGDPRViewController.configure(with: webView)
    }
}
