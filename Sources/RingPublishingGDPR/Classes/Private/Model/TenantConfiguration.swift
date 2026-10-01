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

    // MARK: Methods

    /// CMP url with additional query parameters appended.
    /// A parameter replaces a same-named one already present in the url. Values are percent-encoded once.
    func cmpUrl(appending additionalQueryParameters: [String: String]) -> URL {
        guard !additionalQueryParameters.isEmpty,
              var components = URLComponents(url: cmpUrl, resolvingAgainstBaseURL: false) else { return cmpUrl }

        var queryItems = (components.queryItems ?? []).filter { additionalQueryParameters[$0.name] == nil }
        queryItems += additionalQueryParameters.sorted(by: { $0.key < $1.key }).map { URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems = queryItems

        return components.url ?? cmpUrl
    }
}
