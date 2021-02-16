//
//  RingPublishingGDPRConfig.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 08/02/2021.
//

import Foundation

/// RingPublishingGDPR module configuration
public class RingPublishingGDPRConfig: NSObject {

    /// Does GDPR applies in current context? Defaults to true
    @objc public let gdprApplies: Bool

    /// CMP Tenant Id
    @objc public let tenantId: String

    /// App site id used to brand CMP form
    @objc public let brandName: String

    /// RingPublishingGDPR module UI configuration used for error view & App Tracking Transparency explaination view
    @objc public let uiConfig: RingPublishingGDPRUIConfig

    /// RingPublishingGDPR module configuration for App Tracking Transparency explaination screen & Apple ATT
    @objc public let attConfig: RingPublishingGDPRATTConfig?

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter gdprApplies: Does GDPR applies in current context? Defaults to true
    /// - Parameter tenantId: CMP Tenant Id
    /// - Parameter brandName: App site id used to brand CMP form
    /// - Parameter uiConfig: RingPublishingGDPR module UI configuration used for error view & App Tracking Transparency explaination view
    /// - Parameter attConfig: RingPublishingGDPR module configuration for App Tracking Transparency explaination screen & Apple ATT
    @objc
    public init(gdprApplies: Bool = true,
                tenantId: String,
                brandName: String,
                uiConfig: RingPublishingGDPRUIConfig,
                attConfig: RingPublishingGDPRATTConfig?) {
        self.gdprApplies = gdprApplies
        self.tenantId = tenantId
        self.brandName = brandName
        self.uiConfig = uiConfig
        self.attConfig = attConfig
    }
}
