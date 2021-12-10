//
//  RingPublishingGDPRError.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 10/12/2021.
//  Copyright © 2021 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Enum representing unusual situations encountered by the SDK
@objc
public enum RingPublishingGDPRError: Int {

    /// SDK could not fetch initial tenant configuration and check if consents are up to date within given time limit
    case configurationFetchTimeout = 1

    /// Tenant configuration could not be fetched (or was empty) from the API
    case tenantConfigurationFetchFailed = 2

    /// API check if stored consents are up to date failed
    case consentsStatusFetchFailed = 3

    /// SDK could not load consents form in WebView withing given time limit
    case webViewLoadingTimeout = 4

    /// SDK could not load consents form in WebView
    case webViewLoadingFailed = 5

    /// SDK did detect error in of the JavaScript functions inside consent form
    case webViewJavaScriptFailed = 6
}

extension RingPublishingGDPRError: CustomStringConvertible {

    public var description: String {
        switch self {
        case .configurationFetchTimeout:
            return "configurationFetchTimeout"

        case .tenantConfigurationFetchFailed:
            return "tenantConfigurationFetchFailed"

        case .consentsStatusFetchFailed:
            return "consentsStatusFetchFailed"

        case .webViewLoadingTimeout:
            return "webViewLoadingTimeout"

        case .webViewLoadingFailed:
            return "webViewLoadingFailed"

        case .webViewJavaScriptFailed:
            return "webViewJavaScriptFailed"
        }
    }
}
