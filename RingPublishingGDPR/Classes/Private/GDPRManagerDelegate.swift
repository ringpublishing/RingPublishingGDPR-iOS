//
//  GDPRManagerDelegate.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 13/10/2020.
//

import Foundation
import WebKit

/// GDPRManager internal delegate
protocol GDPRManagerDelegate: class {

    /// Manager is requesting to show consents controller
    ///
    /// - Parameter manager: RingPublishingGDPRManager
    func gdprManagerDidRequestToShowConsentsController(_ manager: GDPRManager)

    /// Manager is requesting to hide consents controller
    ///
    /// - Parameter manager: RingPublishingGDPRManager
    func gdrpManagerDidRequestToHideConsentsController(_ manager: GDPRManager)

    /// Manager is requesting to show different view stte inside view controller
    ///
    /// - Parameters:
    ///   - manager: GDPRManager
    ///   - state: ViewState
    func gdprManager(_ manager: GDPRManager, isRequestingToChangeViewState state: ViewState)

    /// Manager is requesting to embed web view inside view controller
    ///
    /// - Parameters:
    ///   - manager: GDPRManager
    ///   - webView: WKWebView
    func gdprManager(_ manager: GDPRManager, isRequestingToEmbedWebView webView: WKWebView)

    /// Manager is requesting to open url selected inside view controller by the user
    ///
    /// - Parameters:
    ///   - manager: GDPRManager
    ///   - url: URL
    func gdprManager(_ manager: GDPRManager, isRequestingToOpenUrl url: URL)

    /// Manager is informing that user selected on of the options on ATT onboarding screen
    ///
    /// - Parameters:
    ///   - manager: GDPRManager
    ///   - allow: Bool
    func gdprManager(_ manager: GDPRManager, userSelectedATTOnboardingOptionAllowingTracking allow: Bool)

    /// Manager is informing that user selected on of the options on Apple permission alert for ATT
    ///
    /// - Parameters:
    ///   - manager: GDPRManager
    ///   - allow: Bool
    func gdprManager(_ manager: GDPRManager, userSelectedATTAlertPermisionAllowingTracking allow: Bool)
}
