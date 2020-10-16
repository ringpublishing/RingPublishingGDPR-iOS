//
//  ConsentsStatus.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

/// Enum representing status for user consents data returned by CMP API
///
/// - empty: Contents are empty
/// - invalid: Consents are invalid
/// - outdated: Consents are outdated
/// - ok: Consents are correct and up to date
enum ConsentsStatus: String {

    case empty
    case invalid
    case outdated
    case ok

    // MARK: Init

    /// Initialize ConsentsStatus from API status value
    ///
    /// - Parameter apiStatus: String
    init?(from apiStatus: String?) {
        let normalizedStatus = apiStatus?.lowercased()

        guard let statusString = normalizedStatus, let status = ConsentsStatus(rawValue: statusString) else { return nil }

        self = status
    }
}
