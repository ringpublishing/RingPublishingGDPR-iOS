//
//  GDPRManager+WKScriptMessageHandler.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import WebKit

// MARK: WKScriptMessageHandler
extension GDPRManager: WKScriptMessageHandler {

    /// CMP event  key name
    private static let cmpEventStatusKey = "cmpEventStatus"

    /// CMP event payload key name
    private static let cmpEventPayloadKey = "cmpEventPayload"

    // MARK: Delegate

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let messageDictionary = message.body as? [String: Any]
        let cmpRawStatusEvent = messageDictionary?[Self.cmpEventStatusKey] as? String

        guard let eventMessage = cmpRawStatusEvent, let cmpEvent = GDPREvent(from: eventMessage) else { return }

        switch cmpEvent {
        case .cmpWelcomeVisible:
            Logger.log("CMP: WebView initial screen should be visible.")

        case .cmpSettingsVisible:
            Logger.log("CMP: WebView settings screen should be visible.")

        case .loaded, .shown:
            let message = cmpEvent == .loaded ? "CMP: WebView form was loaded, cancelling loading timer..."
                : "CMP: WebView is visible, cancelling loading timer..."
            Logger.log(message)

            webViewLoadingTimer?.invalidate()
            webViewLoadingTimer = nil

            moduleState = .cmpShown

            delegate?.gdprManager(self, isRequestingToChangeViewState: .content)

        case .userInteractionComplete:
            Logger.log("CMP: User did finish interacting with the WebView form.")

            formSubmittedAction()

        case .getInAppTCData:
            Logger.log("CMP: WebView returned standardized user consents.")

            let payload = messageDictionary?[Self.cmpEventPayloadKey] as? [String: Any]
            handleStandardizedConsentsData(from: payload)

        case .getCompleteConsentData:
            Logger.log("CMP: WebView returned RingPublishing consents data.")

            let payload = messageDictionary?[Self.cmpEventPayloadKey] as? [String: Any]
            handleCompleteConsentData(from: payload)

        case .error:
            Logger.log("CMP: JavaScript listeners for CMP were not added - error was returned.", level: .error)

            handleError(GDPRError.javascriptListenersError.nsError)

        case .consentsError:
            let payload = messageDictionary?[Self.cmpEventPayloadKey] as? String
            Logger.log("CMP: JavaScript consents fetch failed - error was returned in function: \(payload.logable)", level: .error)

            handleConsentsFetchError()
        }
    }
}

// MARK: Private
private extension GDPRManager {

    // MARK: Other

    func formSubmittedAction() {
        // Show loading while we are fetching content from JS
        delegate?.gdprManager(self, isRequestingToChangeViewState: .loading)

        // Start timer for receiving data from JS and execute actions
        jsConsentResponseTimer?.invalidate()
        jsConsentResponseTimer = Timer.scheduledTimer(withTimeInterval: jsConsentResponseTimeout, repeats: false, block: { [weak self] _ in
            self?.consentsStored(timeoutReached: true)
        })

        let actionsToPerform: [GDPRAction] = [.getTCData, .getCompleteConsentData]

        actionsRequiredToCloseCMP = actionsToPerform
        actionsToPerform.forEach {
            performAction($0)
        }
    }

    // MARK: Consents storage

    func handleStandardizedConsentsData(from dictionary: [String: Any]?) {
        // Check if we are waiting for this action or consents error occured
        guard actionsRequiredToCloseCMP.contains(.getTCData) else {
            Logger.log("CMP: Action .getTCData will not be processed")
            return
        }

        // Standardized consents
        GDPRStorage.cmpSdkID = dictionary?.value(byKey: "cmpId")
        GDPRStorage.cmpSdkVersion = dictionary?.value(byKey: "cmpVersion")
        GDPRStorage.policyVersion = dictionary?.value(byKey: "tcfPolicyVersion")
        GDPRStorage.gdprApplies = dictionary?.value(byKey: "gdprApplies")
        GDPRStorage.publisherCC = dictionary?.value(byKey: "publisherCC")
        GDPRStorage.purposeOneTreatment = dictionary?.value(byKey: "purposeOneTreatment")
        GDPRStorage.useNonStandardStacks = dictionary?.value(byKey: "useNonStandardStacks")
        GDPRStorage.tcString = dictionary?.value(byKey: "tcString")
        GDPRStorage.vendorConsents = dictionary?.value(byKeyPath: "vendor.consents")
        GDPRStorage.vendorLegitimateInterests = dictionary?.value(byKeyPath: "vendor.legitimateInterests")
        GDPRStorage.purposeConsents = dictionary?.value(byKeyPath: "purpose.consents")
        GDPRStorage.purposeLegitimateInterests = dictionary?.value(byKeyPath: "purpose.legitimateInterests")
        GDPRStorage.specialFeaturesOptIns = dictionary?.value(byKey: "specialFeatureOptins")
        GDPRStorage.publisherConsent = dictionary?.value(byKeyPath: "publisher.consents")
        GDPRStorage.publisherLegitimateInterests = dictionary?.value(byKeyPath: "publisher.legitimateInterests")
        GDPRStorage.publisherCustomPurposesConsents = dictionary?.value(byKeyPath: "publisher.customPurpose.consents")
        GDPRStorage.publisherCustomPurposesLegitimateInterests =
            dictionary?.value(byKeyPath: "publisher.customPurpose.legitimateInterests")

        // Standardized consents (Publisher Restrictions)
        savePublisherRestrictions(from: dictionary)

        // Google’s Additional Consent Mode
        GDPRStorage.addtlConsent = dictionary?.value(byKey: "addtlConsent")

        // Mark that action required to close form view was received
        actionsRequiredToCloseCMP.removeAll { $0 == .getTCData }
        consentsStored()
    }

    func savePublisherRestrictions(from dictionary: [String: Any]?) {
        // Clear old ones in case we had some saved previously but now we don't have them anymore
        GDPRStorage.clearAllPublisherRestrictions()

        // Save new ones
        guard let restrictions: [String: String] = dictionary?.value(byKeyPath: "publisher.restrictions") else { return }

        restrictions.forEach { (key, value) in
            GDPRStorage.storePublisherRestrictions(for: key, restrictions: value)
        }
    }

    func handleCompleteConsentData(from dictionary: [String: Any]?) {
        // Check if we are waiting for this action or consents error occured
        guard actionsRequiredToCloseCMP.contains(.getCompleteConsentData) else {
            Logger.log("CMP: Action .getCompleteConsentData will not be processed")
            return
        }

        // RingPublishing consents
        GDPRStorage.ringPublishingConsents = dictionary?.value(byKey: "consents")
        GDPRStorage.ringPublishingVendorsConsent = dictionary?.value(byKey: "vendorsConsent")

        // Mark that action required to close form view was received
        actionsRequiredToCloseCMP.removeAll { $0 == .getCompleteConsentData }
        consentsStored()
    }
}
