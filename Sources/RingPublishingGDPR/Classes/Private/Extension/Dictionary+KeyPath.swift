//
//  Dictionary+KeyPath.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {

    /// Return value from dictionary
    ///
    /// - Parameter key: String
    /// - Returns: Value if was found
    func value<T>(byKey key: String) -> T? {
        return self[key] as? T
    }

    /// Get value using key path
    ///
    /// - Parameter keyPath: String with key paths separated by .
    /// - Returns: Value if was found
    func value<T>(byKeyPath keyPath: String) -> T? {
        let keys = keyPath.split(separator: ".").map { String($0) }
        let firstKey = keys.first
        let restOfTheKeyPath = keys.dropFirst().joined(separator: ".")

        guard let currentKey = firstKey else { return nil }

        switch keys.count {
        case 1:
            return self[currentKey] as? T

        default:
            let nextDictionary = self[currentKey] as? [String: Any]
            return nextDictionary?.value(byKeyPath: restOfTheKeyPath)
        }
    }
}
