//
//  GDPRManager+WKNavigationDelegate.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import WebKit

// MARK: WKNavigationDelegate
extension GDPRManager: WKNavigationDelegate {

    // swiftlint:disable implicitly_unwrapped_optional

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewHostPageLoaded = true
        Logger.log("CMP: Loading WebView page has been completed")
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }

        // Open link in Safari browser
        if let linkUrl = navigationAction.request.url, UIApplication.shared.canOpenURL(linkUrl) {
            UIApplication.shared.open(linkUrl, options: [:], completionHandler: nil)
        }

        decisionHandler(.cancel)
    }

    // swiftlint:enable implicitly_unwrapped_optional
}
