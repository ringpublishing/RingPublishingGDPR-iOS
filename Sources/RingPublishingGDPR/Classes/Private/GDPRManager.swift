//
//  GDPRManager.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// Class handling internal module logic
class GDPRManager: NSObject {

    /// WebKit message handler name for CMP events
    static let cmpMessageHandlerName = "cmpEvents"

    /// Manager delegate
    weak var delegate: GDPRManagerDelegate?

    /// AppTrackingTransparencyManager
    let appTrackingManager: AppTrackingTransparencyManager

    /// CMP API
    let cmpApi: GDPRApi

    /// Configuration for given tenant id (fetched from API)
    var tenantConfiguration: TenantConfiguration?

    /// Determines if module was initialized with forced GDPR applies state
    var forcedGDPRApplies: Bool?

    /// Last known consents status from API
    var lastAPIConsentsCheckStatus: ConsentsStatus?

    /// Default web view & API timeout
    var timeoutInterval: TimeInterval = 10

    /// Web view loading timer
    var startupLoadingTimer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }

    /// Underlaying "content" view
    var webview: WKWebView?

    /// Web view loading timer
    var webViewLoadingTimer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }

    /// Web view host page loaded?
    var webViewHostPageLoaded = false

    /// Module state
    var moduleState: ModuleState = .unknown {
        didSet {
            guard moduleState == .cmpShown else { return }

            let actions = actionsQueue
            actionsQueue.removeAll()

            actions.forEach {
                Logger.log("CMP is executing action stored in queue: \($0)")
                performAction($0)
            }
        }
    }

    /// Actions queue
    private var actionsQueue: [GDPRAction] = []

    /// Timer used to limit waiting for JS CMP consents response
    var jsConsentResponseTimer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }

    /// Timeout for waiting for JS CMP consents response
    let jsConsentResponseTimeout: TimeInterval = 2

    /// What actions responses must be received from JS to close form
    var actionsRequiredToCloseCMP: [GDPRAction] = []

    /// Should GDPR apply in current context?
    private var gdprApplies: Bool {
        return GDPRStorage.gdprApplies == 1 || GDPRStorage.gdprApplies == nil
    }

    /// Is GDPR consents status not determined?
    var gdprConsentsNotDetermined: Bool {
        return GDPRStorage.tcString == nil && gdprApplies
    }

    /// Are GDPR consents up to date?
    var consentsNotUpToDate: Bool {
        let consentsUpToDateInAPI = lastAPIConsentsCheckStatus == .ok || lastAPIConsentsCheckStatus == nil
        return !consentsUpToDateInAPI && gdprApplies
    }

    /// Is App Tracking Transparency status not determined?
    var attConsentsNotDetermined: Bool {
        return !appTrackingManager.trackingStatusDetermined
    }

    /// Combines GDPR status & App Tracking Trabsparency status
    /// Determined if app should should consent form at app start
    var shouldAskUserForConsents: Bool {
        return gdprConsentsNotDetermined || consentsNotUpToDate || attConsentsNotDetermined
    }

    // MARK: Init

    /// Initializer
    ///
    /// - Parameters:
    ///   - config: RingPublishingGDPRConfig
    ///   - delegate: RingPublishingGDPRManagerDelegate
    ///   - timeoutInterval: WebView and API timeout
    ///   - forcedGDPRApplies: Determines if module was initialized with forced GDPR applies state
    init(config: RingPublishingGDPRConfig, delegate: GDPRManagerDelegate, timeoutInterval: TimeInterval, forcedGDPRApplies: Bool?) {
        self.moduleState = .initialized
        self.delegate = delegate
        self.timeoutInterval = timeoutInterval
        self.forcedGDPRApplies = forcedGDPRApplies

        let attEnabled = config.attConfig?.appTrackingTransparencySupportEnabled ?? false
        self.appTrackingManager = AppTrackingTransparencyManager(appTrackingTransparencySupportEnabled: attEnabled)

        self.cmpApi = GDPRApi(tenantId: config.tenantId, brandName: config.brandName, timeoutInterval: timeoutInterval)
    }

    // MARK: Deinit

    deinit {
        webview?.configuration.userContentController.removeScriptMessageHandler(forName: Self.cmpMessageHandlerName)
        webview?.navigationDelegate = nil
    }

    // MARK: Startup

    func determineConsentsStatusOnStartup() {
        // Access cmpSDKId so our default value can be set
        _ = GDPRStorage.cmpSdkID

        // Start initialization timer
        startupLoadingTimer = Timer.scheduledTimer(withTimeInterval: timeoutInterval, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }

            Logger.log("Startup loading timer fired. Timeout of '\(self.timeoutInterval)'s reached!", level: .error)
            self.startupLoadingTimer = nil
            self.delegate?.gdprManager(self, didEncounterError: .configurationFetchTimeout)
            self.delegate?.gdprManagerDidDetermineThatConsentsAreUpToDate(self)
        })

        // Fetch startup configuration
        fetchStartupConfigurationIfNeeded(forcedGDPRApplies: forcedGDPRApplies) { [weak self] (configuration, consentsStatus, error) in
            // Determine if startup timer fired
            guard let self = self, self.startupLoadingTimer != nil else { return }

            // Invalidate startup timer & process config
            self.startupLoadingTimer = nil
            self.processFetchedStartupConfiguration(configuration: configuration, consentsStatus: consentsStatus, error: error)
        }
    }

    func processFetchedStartupConfiguration(configuration: TenantConfiguration?,
                                            consentsStatus: ConsentsStatus?,
                                            error: Error?) {
        guard let config = configuration, let status = consentsStatus, error == nil else {
            Logger.log("Startup configuration fetch encountered an error! Error: \(error.debugDescription)", level: .error)

            if configuration == nil {
                self.delegate?.gdprManager(self, didEncounterError: .tenantConfigurationFetchFailed)
            }

            if consentsStatus == nil {
                self.delegate?.gdprManager(self, didEncounterError: .consentsStatusFetchFailed)
            }

            self.delegate?.gdprManagerDidDetermineThatConsentsAreUpToDate(self)
            return
        }

        Logger.log("Fetched startup configuration: \(config)")
        Logger.log("Startup consents status determined as: '\(status)'")

        // Store configuration for further use
        tenantConfiguration = config
        lastAPIConsentsCheckStatus = status

        // Store gdprApplies in user defaults
        Logger.log("Received from configuration GDPR applies = \(config.gdprApplies)")
        GDPRStorage.gdprApplies = config.gdprApplies ? 1 : 0

        // Determine if consents controller should be shown
        let shouldAsk = shouldAskUserForConsents
        Logger.log("Checking if consents controller should be shown -> \(shouldAsk)")
        Logger.log("Check result: GDPR consents NOT stored - \(gdprConsentsNotDetermined)")
        Logger.log("Check result: GDPR consents NOT up to date - \(consentsNotUpToDate)")
        Logger.log("Check result: ATT status NOT determined - \(attConsentsNotDetermined)")

        if shouldAsk {
            delegate?.gdprManagerDidRequestToShowConsentsController(self)
        } else {
            delegate?.gdprManagerDidDetermineThatConsentsAreUpToDate(self)
        }
    }

    // MARK: WebView

    func initializeWebView() {
        let webview = WKWebView(frame: UIScreen.main.bounds, configuration: WebViewConfiguration.defaultConfiguration)
        webview.customUserAgent = UserAgent.defaultUserAgent
        webview.configuration.userContentController.add(WKScriptMessageHandlerWrapper(delegate: self), name: Self.cmpMessageHandlerName)
        webview.navigationDelegate = self

        // Set background color
        let bgColor = UIColor(named: "ringPublishingGDPRBackground", in: Bundle.ringPublishingGDPRBundle, compatibleWith: nil)
        webview.backgroundColor = bgColor
        webview.underPageBackgroundColor = bgColor

        self.webview = webview

        delegate?.gdprManager(self, isRequestingToEmbedWebView: webview)
    }

    // MARK: CMP site loading

    /// Load CMP site into WKWebView
    func loadCMPSite() {
        // Set loading state
        moduleState = .cmpLoading
        webViewHostPageLoaded = false

        delegate?.gdprManager(self, isRequestingToChangeViewState: .loading)

        // Start loading timer
        webViewLoadingTimer = Timer.scheduledTimer(withTimeInterval: timeoutInterval, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }

            self.webview?.stopLoading()
            self.delegate?.gdprManager(self, didEncounterError: .webViewLoadingTimeout)

            guard self.webViewHostPageLoaded else { return }

            // Send error manually so we can exist form view
            let error = GDPRError.timeout.nsError
            self.handleError(error)
        })

        // Use stored configuration if we have it already
        if let configuration = tenantConfiguration, moduleState != .cmpError {
            // Load web page
            Logger.log("Loading CMP site using already fetched configuration. Loading url: \(configuration.cmpUrl)")

            let request = URLRequest(url: configuration.cmpUrl)
            webview?.load(request)
            return
        }

        // Fetch config for tenant and load web page
        Logger.log("Loading CMP site - configuration not present - fetching...")

        fetchStartupConfigurationIfNeeded(forcedGDPRApplies: forcedGDPRApplies) { [weak self] (configuration, _, error) in
            guard let strongSelf = self, let tenantConfig = configuration, strongSelf.moduleState != .cmpError else {
                // Send error manually as we did not even start to load web page
                let errorToHandle = error ?? GDPRError.tenantConfigError.nsError
                self?.handleError(errorToHandle)
                return
            }

            // Load web page
            Logger.log("Loading CMP site using freshly fetched configuration. Loading url: \(tenantConfig.cmpUrl)")

            let request = URLRequest(url: tenantConfig.cmpUrl)
            strongSelf.webview?.load(request)
        }
    }

    /// Handle WKWebView error and show proper error state if needed
    ///
    /// - Parameter error: Error
    func handleError(_ error: Error) {
        Logger.log("CMP loading error: \(error)", level: .error)

        // Cancel loading timer
        Logger.log("Cancelling CMP loading timer due to loading error...")
        webViewLoadingTimer = nil

        guard !attConsentsNotDetermined else {
            Logger.log("AppTrackingTransparency consent status is not determined. Requesting to show explanation view...")
            delegate?.gdprManager(self, isRequestingToChangeViewState: .appTrackingTransparency)
            moduleState = .initialized
            return
        }

        if [NSURLErrorNotConnectedToInternet, NSURLErrorDataNotAllowed].contains((error as NSError).code) {
            // Show error state only if we know that there was no Internet access
            delegate?.gdprManager(self, isRequestingToChangeViewState: .error)
            return
        }

        // Call delegate that ringPublishingGDPR view should be closed and return all consents set to false
        delegate?.gdrpManagerDidRequestToHideConsentsController(self)

        // Set error state so next action would trigger cmp site load
        moduleState = .cmpError
    }

    // MARK: JavaScript evaluation / CMP actions

    /// Sends message to JavaScript to perform desired action
    ///
    /// - Parameter cmpAction: GDPRAction
    func performAction(_ cmpAction: GDPRAction) {
        if moduleState == .cmpShown {
            Logger.log("CMP web site is loaded, executing action: \(cmpAction)")
            webview?.evaluateJavaScript(cmpAction.javaScriptCode, completionHandler: nil)
            return
        }

        // Add actions to queue or load CMP
        let isActionAlreadyInQueue = actionsQueue.contains { queueAction -> Bool in
            return queueAction.javaScriptCode == cmpAction.javaScriptCode
        }

        if !isActionAlreadyInQueue {
            Logger.log("CMP site is not yet loaded, adding action to queue: \(cmpAction)")
            actionsQueue.append(cmpAction)
        } else {
            Logger.log("CMP site is not yet loaded, but action: \(cmpAction) is already added to queue")
        }

        // If we are in error state, try to load web page again
        if moduleState == .cmpError {
            Logger.log("Starting CMP site load because module is in error state! Action trigger: \(cmpAction)")
            loadCMPSite()
        }

        if moduleState == .initialized {
            Logger.log("Initializing WebView and starting CMP site load based on action: \(cmpAction)")

            // Load CMP
            initializeWebView()
            loadCMPSite()
        }
    }

    /// Called after some consents from given action have been stored and checks if we should close form view
    ///
    /// - Parameter timeoutReached: True if timeout was reached and we should close form view
    func consentsStored(timeoutReached: Bool = false) {
        if timeoutReached {
            Logger.log("CMP did not return all consents. Timeout reached. Requesting to close form...", level: .error)
            handleConsentsFetchError()
            return
        }

        guard actionsRequiredToCloseCMP.isEmpty else { return }

        Logger.log("CMP did return all consents.")

        jsConsentResponseTimer?.invalidate()
        jsConsentResponseTimer = nil

        closeCMPFormAfterReceivingConsents()
    }

    func handleConsentsFetchError() {
        Logger.log("Clearing all consents due to consents fetch error/timeout.")

        // Clear required actions so action which not failed can't store consents data
        actionsRequiredToCloseCMP.removeAll()

        // Invalidate timer
        jsConsentResponseTimer = nil

        // Remove all consents
        GDPRStorage.clearAllConsentData()

        // Close form
        closeCMPFormAfterReceivingConsents()
    }

    func closeCMPFormAfterReceivingConsents() {
        // Remove last stored consents status after consents save
        lastAPIConsentsCheckStatus = nil

        guard !attConsentsNotDetermined else {
            Logger.log("AppTrackingTransparency consent status is not determined. Requesting to show explanation view...")
            delegate?.gdprManager(self, isRequestingToChangeViewState: .appTrackingTransparency)
            return
        }

        // Request to close form
        Logger.log("Requesting to close form view controller...")
        delegate?.gdrpManagerDidRequestToHideConsentsController(self)
    }
}
