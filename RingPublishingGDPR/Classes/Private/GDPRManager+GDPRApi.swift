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

    /// Fetch CMP configuration for given tenant
    ///
    /// - Parameter completion: Completion handler
    func fetchCMPConfigurationIfNeeded(completion: @escaping (_ configuration: TenantConfiguration?, _ error: Error?) -> Void) {
        // Fetch only if don't have it stored already
        guard tenantConfiguration == nil else {
            completion(tenantConfiguration, nil)
            return
        }

        Logger.log("Asking CMP API for tenant configuration...")

        cmpApi?.getCMPTenantConfiguration(completion: { [weak self] (config, error) in
            Logger.log("CMP API did return tenant configuration? -> \(config != nil)")

            DispatchQueue.main.async {
                self?.tenantConfiguration = config
                completion(config, error)
            }
        })
    }

    // Check if consents stored on this device are up to date; if not inform about it
    func checkUserConsentsStatus() {
        // Check if we have stored consents status in cache
        let lastAPIStatusValue = GDPRStorage.lastAPIConsentsCheckStatus

        guard let rawStatus = lastAPIStatusValue, let status = ConsentsStatus(rawValue: rawStatus), status != .ok else {
            Logger.log("Asking CMP API for current user consents status...")
            checkUserConsentsStatusInAPI()
            return
        }

        // We have invalid status stored for user consents, we don't have to ask API again for it
        Logger.log("Module has stored invalid user consents status: '\(rawStatus)', informing delegate...")
        delegate?.gdprManagerDidRequestToShowConsentsController(self)
    }
}

// MARK: Private
private extension GDPRManager {

    func checkUserConsentsStatusInAPI() {
        let ringPublishingConsents = GDPRStorage.ringPublishingConsents

        cmpApi?.getConsentsStatus(for: ringPublishingConsents, completion: { [weak self] status in
            defer {
                GDPRStorage.lastAPIConsentsCheckStatus = status?.rawValue
            }

            Logger.log("CMP API did return consents status: \(status.logable)")

            guard let self = self, let status = status, status != .ok else { return }

            DispatchQueue.main.async {
                self.delegate?.gdprManagerDidRequestToShowConsentsController(self)
            }
        })
    }
}
