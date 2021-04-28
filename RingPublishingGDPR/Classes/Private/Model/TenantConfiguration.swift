//
//  TenantConfiguration.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Configuration for given tenant id
struct TenantConfiguration {

    /// Url where CMP form is located for given tenant id
    let cmpUrl: URL

    /// Does GDPR applies in current session / context?
    let gdprApplies: Bool

    // MARK: Init

    init?(urlString: String, gdprApplies: Bool) {
        guard let url = URL(string: urlString) else { return nil }

        self.cmpUrl = url
        self.gdprApplies = gdprApplies
    }
}
