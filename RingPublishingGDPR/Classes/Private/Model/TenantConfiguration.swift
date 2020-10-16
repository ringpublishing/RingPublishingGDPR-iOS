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

    // MARK: Init

    init?(urlString: String?) {
        guard let rawUrl = urlString, let url = URL(string: rawUrl) else { return nil }

        self.cmpUrl = url
    }
}
