//
//  RingPublishingGDPRConfig.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 08/02/2021.
//

import Foundation

/// RingPublishingGDPR module configuration
public class RingPublishingGDPRConfig: NSObject {

    /// CMP Tenant Id
    @objc public let tenantId: String

    /// App site id used to brand CMP form
    @objc public let brandName: String

    /// RingPublishingGDPR module UI configuration used for error view & App Tracking Transparency explanation view
    @objc public let uiConfig: RingPublishingGDPRUIConfig

    /// RingPublishingGDPR module configuration for App Tracking Transparency explanation screen & Apple ATT
    @objc public let attConfig: RingPublishingGDPRATTConfig?

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter tenantId: CMP Tenant Id
    /// - Parameter brandName: App site id used to brand CMP form
    /// - Parameter uiConfig: RingPublishingGDPR module UI configuration used for error view & App Tracking Transparency explanation view
    /// - Parameter attConfig: RingPublishingGDPR module configuration for App Tracking Transparency explanation screen & Apple ATT
    @objc
    public init(tenantId: String,
                brandName: String,
                uiConfig: RingPublishingGDPRUIConfig,
                attConfig: RingPublishingGDPRATTConfig?) {
        self.tenantId = tenantId
        self.brandName = brandName
        self.uiConfig = uiConfig
        self.attConfig = attConfig
    }
}
