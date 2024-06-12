//
//  Bundle+RingPublishingGDPR.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Resources bundle for module
extension Bundle {

    static var ringPublishingGDPRBundle: Bundle {
        guard let bundlePath = Bundle.main.path(forResource: "RingPublishingGDPR_RingPublishingGDPR", ofType: "bundle") else { return Bundle.main }

        return Bundle(path: bundlePath) ?? .main
    }
}
