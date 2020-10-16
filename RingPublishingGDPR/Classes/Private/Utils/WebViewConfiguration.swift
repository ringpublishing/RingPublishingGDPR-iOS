//
//  WebViewConfiguration.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// WKWebView configuration helper
class WebViewConfiguration {

    /// JavaScript scripts used in underlaying web view
    private static let jsScripts = ["CMPEventListeners"]

    // MARK: WKWebView config

    /// Extend WKWebView configuration by adding user content controller and JS event listeners
    static var defaultConfiguration: WKWebViewConfiguration {
        let wkUserController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = wkUserController

        // Insert scripts
        Self.jsScripts.compactMap {
            guard let url = Bundle.ringPublishingGDPRBundle.url(forResource: $0, withExtension: "js"),
                let jsScript = try? String(contentsOf: url) else {
                    return nil
            }

            return WKUserScript(source: jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        }.forEach {
            wkUserController.addUserScript($0)
        }

        return config
    }
}
