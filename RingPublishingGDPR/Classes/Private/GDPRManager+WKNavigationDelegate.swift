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

        let loadedUrl = webView.url?.absoluteString
        Logger.log("CMP: Loading WebView page has been completed. Currently loaded url: \(loadedUrl.logable)")
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let loadedUrl = webView.url?.absoluteString
        Logger.log("CMP: WebView did fail navigation. Currently loaded url: \(loadedUrl.logable)", level: .error)

        handleError(error)
        delegate?.gdprManager(self, didEncounterError: .webViewLoadingFailed)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let loadedUrl = webView.url?.absoluteString
        Logger.log("CMP: WebView did fail provisional navigation. Currently loaded url: \(loadedUrl.logable)", level: .error)

        handleError(error)
        delegate?.gdprManager(self, didEncounterError: .webViewLoadingFailed)
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let navigationUrl = navigationAction.request.url?.absoluteString

        guard navigationAction.navigationType == .linkActivated else {
            Logger.log("CMP: WebView decide policy - allow for url: \(navigationUrl.logable)")

            decisionHandler(.allow)
            return
        }

        // Open link in Safari browser
        if let linkUrl = navigationAction.request.url, UIApplication.shared.canOpenURL(linkUrl) {
            Logger.log("CMP: WebView decide policy - opening in Safari: \(linkUrl)")
            UIApplication.shared.open(linkUrl, options: [:], completionHandler: nil)
        }

        Logger.log("CMP: WebView decide policy - cancel for url: \(navigationUrl.logable)")
        decisionHandler(.cancel)
    }

    // swiftlint:enable implicitly_unwrapped_optional
}
