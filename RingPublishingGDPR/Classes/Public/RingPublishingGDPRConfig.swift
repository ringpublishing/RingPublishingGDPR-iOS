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
    @objc
    public let gdprApplies: Bool

    /// CMP Tenant Id
    @objc
    public let tenantId: String

    /// App site id used to brand CMP form
    @objc
    public let brandName: String

    /// Should Apple App Tracking Transparency permission alert be shown after GDPR consents screen?
    ///
    /// If this option is enabled, texts for "onboarding" (scren before alert is shown) should be provided inside 'RingPublishingGDPRUIConfig'
    @objc
    public let supportsAppTrackingTransparency: Bool

    // MARK: Init

    /// Initializer
    ///
    /// - Parameter gdprApplies: Does GDPR applies in current context? Defaults to true
    /// - Parameter tenantId: CMP Tenant Id
    /// - Parameter brandName: App site id used to brand CMP form
    /// - Parameter supportsAppTrackingTransparency: Should Apple App Tracking Transparency permission alert be shown after GDPR consents screen?
    @objc
    public init(gdprApplies: Bool = true, tenantId: String, brandName: String, supportsAppTrackingTransparency: Bool) {
        self.gdprApplies = gdprApplies
        self.tenantId = tenantId
        self.brandName = brandName
        self.supportsAppTrackingTransparency = supportsAppTrackingTransparency
    }
}
