//
//  ViewState.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 13/10/2020.
//

import Foundation

/// Enum representing possible view controller state
///
/// - gdprConsents: WebView content is visible
/// - appTrackingTransparency: AppTrackingTransparency view is shown
/// - loading: Loading view is visible
/// - error: Error view is visible
enum ViewState {

    case gdprConsents
    case appTrackingTransparency
    case loading
    case error
}
