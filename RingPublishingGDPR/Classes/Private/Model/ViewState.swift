//
//  ViewState.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 13/10/2020.
//

import Foundation

/// Enum representing possible view controller state
///
/// - content: WebView content is visible
/// - loading: Loading view is visible
/// - error: Error view is visible
enum ViewState {

    case content
    case loading
    case error
}
