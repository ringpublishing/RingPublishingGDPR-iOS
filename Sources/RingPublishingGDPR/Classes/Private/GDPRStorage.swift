//
//  GDPRStorage.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

class GDPRStorage {

    private static let ringPublishingKeyPrefix = "RingPublishing_"
    private static let iabtcfKeyPrefix = "IABTCF_"
    private static let publisherRestrictionsKeyPrefix = "IABTCF_PublisherRestrictions"

    // MARK: Init

    private init() {

    }

    // MARK: Storage clearing

    /// Clear all consent data except for: "IABTCF_CmpSdkID" and "IABTCF_gdprApplies"
    static func clearAllConsentData() {
        let allKeys = UserDefaults.standard.dictionaryRepresentation().keys.map { String($0) }
        let consentsKeys = allKeys.filter { $0.starts(with: Self.iabtcfKeyPrefix) || $0.starts(with: ringPublishingKeyPrefix) }

        consentsKeys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
            Logger.log("CMP: Clearing previously stored consent data for key: \($0)")
        }
    }

    // MARK: Standardized consents

    @ConsentStorage(key: "IABTCF_CmpSdkID", defaultValue: GDPRConstants.cmpSdkID)
    static var cmpSdkID: Int?

    @ConsentStorage(key: "IABTCF_CmpSdkVersion")
    static var cmpSdkVersion: Int?

    @ConsentStorage(key: "IABTCF_PolicyVersion")
    static var policyVersion: Int?

    @ConsentStorage(key: "IABTCF_gdprApplies")
    static var gdprApplies: Int?

    @ConsentStorage(key: "IABTCF_PublisherCC")
    static var publisherCC: String?

    @ConsentStorage(key: "IABTCF_PurposeOneTreatment")
    static var purposeOneTreatment: Int?

    @ConsentStorage(key: "IABTCF_UseNonStandardTexts")
    static var useNonStandardTexts: Int?

    @ConsentStorage(key: "IABTCF_TCString")
    static var tcString: String?

    @ConsentStorage(key: "IABTCF_VendorConsents")
    static var vendorConsents: String?

    @ConsentStorage(key: "IABTCF_VendorLegitimateInterests")
    static var vendorLegitimateInterests: String?

    @ConsentStorage(key: "IABTCF_PurposeConsents")
    static var purposeConsents: String?

    @ConsentStorage(key: "IABTCF_PurposeLegitimateInterests")
    static var purposeLegitimateInterests: String?

    @ConsentStorage(key: "IABTCF_SpecialFeaturesOptIns")
    static var specialFeaturesOptIns: String?

    @ConsentStorage(key: "IABTCF_PublisherConsent")
    static var publisherConsent: String?

    @ConsentStorage(key: "IABTCF_PublisherLegitimateInterests")
    static var publisherLegitimateInterests: String?

    @ConsentStorage(key: "IABTCF_PublisherCustomPurposesConsents")
    static var publisherCustomPurposesConsents: String?

    @ConsentStorage(key: "IABTCF_PublisherCustomPurposesLegitimateInterests")
    static var publisherCustomPurposesLegitimateInterests: String?

    // MARK: Standardized consents (Publisher Restrictions)

    static func storePublisherRestrictions(for purposeId: String, restrictions: String) {
        let key = "\(Self.publisherRestrictionsKeyPrefix)\(purposeId)"

        UserDefaults.standard.set(restrictions, forKey: key)
        Logger.log("CMP: Storing consents, under: '\(key)' value: '\(restrictions)'")
    }

    static func clearAllPublisherRestrictions() {
        let allKeys = UserDefaults.standard.dictionaryRepresentation().keys.map { String($0) }
        let restrictionsKeys = allKeys.filter { $0.starts(with: Self.publisherRestrictionsKeyPrefix) }

        restrictionsKeys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
            Logger.log("CMP: Clearing previously stored consent data for key: \($0)")
        }
    }

    // MARK: Google’s Additional Consent Mode

    @ConsentStorage(key: "IABTCF_AddtlConsent")
    static var addtlConsent: String?

    // MARK: RingPublishing consents

    @ConsentStorage(key: "RingPublishing_Consents")
    static var ringPublishingConsents: [String: Any]?

    @ConsentStorage(key: "RingPublishing_PublicConsents")
    static var ringPublishingPublicConsents: [String: Any]?

    @ConsentStorage(key: "RingPublishing_VendorsConsent")
    static var ringPublishingVendorsConsent: Int?
}
