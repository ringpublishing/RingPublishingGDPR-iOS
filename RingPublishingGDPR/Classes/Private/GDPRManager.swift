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

    /// CMP API
    var cmpApi: GDPRApi?

    /// Configuration for given tenant id (fetched from API)
    var tenantConfiguration: TenantConfiguration?

    /// Default web view & API timeout
    var timeoutInterval: TimeInterval = 10

    /// Underlaying "content" view
    var webview: WKWebView?

    /// Web view loading timer
    var webViewLoadingTimer: Timer?

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
    var jsConsentResponseTimer: Timer?

    /// Timeout for waiting for JS CMP consents response
    let jsConsentResponseTimeout: TimeInterval = 2

    /// What actions responses must be received from JS to close form
    var actionsRequiredToCloseCMP: [GDPRAction] = []

    /// Should we check if stored consents are still valid? (Could be outdated for example)
    var shouldCheckConsentStatus: Bool {
        return GDPRStorage.tcString != nil && GDPRStorage.gdprApplies == 1
    }

    // MARK: Init

    /// Initializer
    /// 
    /// - Parameters:
    ///   - tenantId: CMP Tenant Id
    ///   - brandName: App site id used to brand CMP form
    ///   - delegate: RingPublishingGDPRManagerDelegate
    ///   - timeoutInterval: WebView and API timeout
    init(tenantId: String, brandName: String, delegate: GDPRManagerDelegate, timeoutInterval: TimeInterval) {
        self.moduleState = .initialized
        self.delegate = delegate
        self.timeoutInterval = timeoutInterval
        self.cmpApi = GDPRApi(tenantId: tenantId, brandName: brandName, timeoutInterval: timeoutInterval)
    }

    // MARK: Deinit

    deinit {
        webview?.configuration.userContentController.removeScriptMessageHandler(forName: Self.cmpMessageHandlerName)
        webview?.navigationDelegate = nil
    }

    // MARK: GDPR Applies

    /// Configure manager & module state
    ///
    /// This method sets "IABTCF_CmpSdkID" and "IABTCF_gdprApplies" values in User Defaults
    /// If GDPR does NOT apply in current context, this will also clear all stored consents
    /// - Parameter gdprApplies: Bool
    func configure(gdprApplies: Bool) {
        // Access cmpSDKId so our default value can be set
        _ = GDPRStorage.cmpSdkID
        GDPRStorage.gdprApplies = gdprApplies ? 1 : 0
    }

    // MARK: WebView

    func initializeWebView() {
        let webview = WKWebView(frame: UIScreen.main.bounds, configuration: WebViewConfiguration.defaultConfiguration)
        webview.customUserAgent = UserAgent.defaultUserAgent
        webview.configuration.userContentController.add(WKScriptMessageHandlerWrapper(delegate: self), name: Self.cmpMessageHandlerName)
        webview.navigationDelegate = self

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
        webViewLoadingTimer?.invalidate()
        webViewLoadingTimer = Timer.scheduledTimer(withTimeInterval: timeoutInterval, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }

            self.webview?.stopLoading()

            guard self.webViewHostPageLoaded else { return }

            // Send error manually so we can exist form view
            let error = GDPRError.timeout.nsError
            self.handleError(error)
        })

        // Fetch config for tenant and load web page
        fetchCMPConfigurationIfNeeded { [weak self] (config, error) in
            guard let strongSelf = self, let tenantConfig = config, strongSelf.moduleState != .cmpError else {
                // Send error manually as we did not even start to load web page
                let errorToHandle = error ?? GDPRError.tenantConfigError.nsError
                self?.handleError(errorToHandle)
                return
            }

            // Load web page
            let request = URLRequest(url: tenantConfig.cmpUrl)
            strongSelf.webview?.load(request)
        }
    }

    /// Handle WKWebView error and show proper error state if needed
    ///
    /// - Parameter error: Error
    func handleError(_ error: Error) {
        let errorMessage = "CMP loading error: \(error.localizedDescription)"
        Logger.log(errorMessage, level: .error)

        // Cancel loading timer
        Logger.log("Cancelling CMP loading timer due to loading error...")
        webViewLoadingTimer?.invalidate()
        webViewLoadingTimer = nil

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
        jsConsentResponseTimer?.invalidate()
        jsConsentResponseTimer = nil

        // Remove all consents
        GDPRStorage.clearAllConsentData()

        // Close form
        closeCMPFormAfterReceivingConsents()
    }

    func closeCMPFormAfterReceivingConsents() {
        // Remove last stored consents status after consents save
        GDPRStorage.lastAPIConsentsCheckStatus = nil

        // Request to close form
        Logger.log("Requesting to close form view controller...")
        delegate?.gdrpManagerDidRequestToHideConsentsController(self)
    }
}
