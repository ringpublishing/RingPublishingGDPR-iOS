//
//  GDPREvent.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Events possible to receive from CMP tool
///
/// - loaded: JavaScript form was loaded
/// - shown: Form is visible on the screen
/// - cmpWelcomeVisible: Confirmation from our internal API that form is visible
/// - cmpSettingsVisible: Confirmation from our internal API that form detail screen is visible
/// - userInteractionComplete: Form was submitted by the user
/// - getInAppTCData: Get standardized user consents
/// - getCompleteConsentData: Get complete consent data
/// - error: Something went wrong with event listeners
/// - consentsError: There was error while fetching consents from CMP JS API
enum GDPREvent {

    case loaded
    case shown
    case cmpWelcomeVisible
    case cmpSettingsVisible
    case userInteractionComplete
    case getInAppTCData
    case getCompleteConsentData
    case error
    case consentsError

    // MARK: Init

    /// Initialize CMPEvent from JavaScript message
    ///
    /// - Parameter message: String
    init?(from message: String) {
        switch message {
        case "tcloaded":
            self = .loaded

        case "cmpuishown":
            self = .shown

        case "cmpWelcomeVisible":
            self = .cmpWelcomeVisible

        case "cmpSettingsVisible":
            self = .cmpSettingsVisible

        case "useractioncomplete":
            self = .userInteractionComplete

        case "getInAppTCData":
            self = .getInAppTCData

        case "getCompleteConsentData":
            self = .getCompleteConsentData

        case "error":
            self = .error

        case "consentsError":
            self = .consentsError

        default:
            print("Received unrecognized message from Javascript: \(String(describing: message))")
            return nil
        }
    }
}
