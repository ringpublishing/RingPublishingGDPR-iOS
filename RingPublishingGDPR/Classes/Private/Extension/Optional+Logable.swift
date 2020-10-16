//
//  Optional+Logable.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

extension Optional {

    /// Use this wrapper to log optional value without wrapping it in Optional(...) description
    var logable: Any {
        switch self {
        case .none:
            return "nil"

        case let .some(value):
            return value
        }
    }
}
