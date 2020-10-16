//
//  ConsentStorage.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Property wrapper used to store user consents in UserDefaults
@propertyWrapper
struct ConsentStorage<T> {

    private let defaults = UserDefaults.standard
    private let key: String
    private let logableAsConsent: Bool

    var wrappedValue: T? {
        get {
            return defaults.object(forKey: key) as? T
        }
        set {
            defaults.set(newValue, forKey: key)

            guard logableAsConsent else { return }

            Logger.log("CMP: Storing consents, under: '\(key)' value: '\(newValue.logable)'")
        }
    }

    // MARK: Init

    init(key: String, logableAsConsent: Bool = true) {
        self.key = key
        self.logableAsConsent = logableAsConsent
    }
}
