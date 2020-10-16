//
//  ModuleState.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Enum representing module state in context of CMP website in WKWebView
///
/// - unknown: Module initial state before initialization
/// - initialized: Module was initialized but did not start loading cmp site yet
/// - cmpLoading: CMP site is loading
/// - cmpShown CMP site is shown and can accept actions
/// - cmpError: CMP site loading failed
enum ModuleState {

    case unknown
    case initialized
    case cmpLoading
    case cmpShown
    case cmpError
}
