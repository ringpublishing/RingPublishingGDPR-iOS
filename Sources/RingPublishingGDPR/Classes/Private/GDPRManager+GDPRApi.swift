//
//  GDPRManager+GDPRApi.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Functionality related to CMP API
extension GDPRManager {

    typealias StartupConfigurationCallback = (_ configuration: TenantConfiguration?,
                                              _ consentsStatus: ConsentsStatus?,
                                              _ error: Error?) -> Void

    func fetchStartupConfigurationIfNeeded(forcedGDPRApplies: Bool?, completion: @escaping StartupConfigurationCallback) {
        guard tenantConfiguration == nil || lastAPIConsentsCheckStatus == nil else {
            completion(tenantConfiguration, lastAPIConsentsCheckStatus, nil)
            return
        }

        var fetchedTenantConfig: TenantConfiguration?
        var fetchedConsentsStatus: ConsentsStatus?
        var fetchError: Error?

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()

        dispatchGroup.notify(queue: .main) {
            completion(fetchedTenantConfig, fetchedConsentsStatus, fetchError)
        }

        fetchCMPConfiguration(forcedGDPRApplies: forcedGDPRApplies) { (configuration, error) in
            fetchedTenantConfig = configuration
            fetchError = fetchError ?? error

            dispatchGroup.leave()
        }

        fetchUserConsentsStatus { (consentsStatus, error) in
            fetchedConsentsStatus = consentsStatus
            fetchError = fetchError ?? error

            dispatchGroup.leave()
        }
    }
}

// MARK: Private
private extension GDPRManager {

    /// Fetch CMP configuration for given tenant
    ///
    /// - Parameter forcedGDPRApplies: Bool
    /// - Parameter completion: Completion handler
    func fetchCMPConfiguration(forcedGDPRApplies: Bool?,
                               completion: @escaping (_ configuration: TenantConfiguration?, _ error: Error?) -> Void) {
        Logger.log("Asking CMP API for tenant configuration...")

        cmpApi.getCMPTenantConfiguration(forcedGDPRApplies: forcedGDPRApplies, completion: { (config, error) in
            Logger.log("CMP API did return tenant configuration? -> \(config != nil)")
            completion(config, error)
        })
    }

    /// Fetch CMP consents status based on currently stored on the device
    ///
    /// - Parameter completion: Completion handler
    func fetchUserConsentsStatus(completion: @escaping (_ consentsStatus: ConsentsStatus?, _ error: Error?) -> Void) {
        Logger.log("Asking CMP API for user consents status...")

        let ringPublishingConsents = GDPRStorage.ringPublishingConsents

        cmpApi.getConsentsStatus(for: ringPublishingConsents, completion: { (status, error) in
            Logger.log("CMP API did return consents status: \(status.logable)")
            completion(status, error)
        })
    }
}
