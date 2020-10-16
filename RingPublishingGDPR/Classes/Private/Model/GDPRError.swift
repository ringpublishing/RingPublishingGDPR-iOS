//
//  GDPRError.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

enum GDPRError: Int {

    case timeout
    case tenantConfigError
    case javascriptListenersError

    var nsError: NSError {
        return NSError(domain: "CMP", code: self.rawValue, userInfo: [NSLocalizedDescriptionKey: logDescription])
    }

    private var logDescription: String {
        switch self {
        case .timeout:
            return "CMP loading timeout was reached."

        case .tenantConfigError:
            return "Loading configuration for given tenantId failed."

        case .javascriptListenersError:
            return "JavaScript listeners for CMP were not added."
        }
    }
}
