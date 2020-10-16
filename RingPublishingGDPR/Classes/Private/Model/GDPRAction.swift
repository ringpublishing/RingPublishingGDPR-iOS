//
//  GDPRAction.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Actions possible to perform with CMP tool
///
/// - showWelcomeScreen: Show consents welcome screen
/// - showSettingsScreen: Show consents setting screen
/// - getTCData Get standard consent data from JS
/// - getCompleteConsentData: Retrieves consent data
enum GDPRAction {

    case showWelcomeScreen
    case showSettingsScreen
    case getTCData
    case getCompleteConsentData

    /// Get JavaScript code for given action
    var javaScriptCode: String {
        switch self {
        case .showWelcomeScreen:
            return """
            window.dlApi.showConsentTool(null, function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": "cmpWelcomeVisible"});
            });
            """

        case .showSettingsScreen:
            return """
            window.dlApi.showConsentTool("details", function () {
                webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": "cmpSettingsVisible"});
            });
            """

        case .getTCData:
            return """
            window.__tcfapi('getInAppTCData', 2, function(data, success) {
                if (success) {
                    webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": "getInAppTCData", "cmpEventPayload": data});
                } else {
                    webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": "consentsError", "cmpEventPayload": "getInAppTCData"});
                }
            });
            """

        case .getCompleteConsentData:
            return """
            window.dlApi.getCompleteConsentData(function(error, data) {
                if (error) {
                    webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": "consentsError", "cmpEventPayload": "getCompleteConsentData"});
                } else {
                    webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": "getCompleteConsentData", "cmpEventPayload": data});
                }
            });
            """
        }
    }
}
