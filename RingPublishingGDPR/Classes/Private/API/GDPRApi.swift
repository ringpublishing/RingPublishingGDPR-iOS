//
//  GDPRApi.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

/// Class responsible for communication with CMP API
class GDPRApi {

    /// API base url
    private let apiBaseUrl = "https://cmp.ringpublishing.com"

    /// CMP Tenant Id
    private let tenantId: String

    /// App site id used to brand CMP form
    private let brandName: String

    /// Underlaying url session
    private let session: URLSession

    // MARK: Init

    /// Initializer
    ///
    /// - Parameters:
    ///   - tenantId: String
    ///   - brandName: String
    ///   - timeoutInterval: TimeInterval
    init(tenantId: String, brandName: String, timeoutInterval: TimeInterval) {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = timeoutInterval
        sessionConfiguration.httpAdditionalHeaders = [
            "User-Agent": UserAgent.defaultUserAgent
        ]

        self.tenantId = tenantId
        self.brandName = brandName
        self.session = URLSession(configuration: sessionConfiguration)
    }

    // MARK: Methods

    func getCMPTenantConfiguration(forcedGDPRApplies: Bool?,
                                   completion: @escaping (_ configuration: TenantConfiguration?, _ error: Error?) -> Void) {
        var urlComponents = URLComponents(string: "\(apiBaseUrl)/\(tenantId)/mobile")
        urlComponents?.queryItems = [
            URLQueryItem(name: "site", value: brandName)
        ]

        if let forcedGDPR = forcedGDPRApplies {
            urlComponents?.queryItems?.append(URLQueryItem(name: "forced_gdpr", value: forcedGDPR ? "1" : "0"))
        }

        guard let url = urlComponents?.url else {
            Logger.log("Configuration url could not be constructed!", level: .error)
            completion(nil, nil)
            return
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            guard let apiData = data,
                  let json = try? JSONSerialization.jsonObject(with: apiData, options: .allowFragments) as? [String: Any],
                  let cmpUrl = json["webview_url"] as? String,
                  let gdprApplies = json["gdpr_applies"] as? Bool else {
                Logger.log("Tenant configuration from API could not be parsed!", level: .error)
                completion(nil, error)
                return
            }

            let configuration = TenantConfiguration(urlString: cmpUrl, gdprApplies: gdprApplies)
            completion(configuration, nil)
        }

        task.resume()
    }

    /// Fetch consents status
    ///
    /// - Parameters:
    ///   - consents: RingPublishing consents
    ///   - completion: Completion handler
    func getConsentsStatus(for consents: [String: Any]?, completion: @escaping (_ status: ConsentsStatus?, _ error: Error?) -> Void) {
        guard let consents = consents else {
            completion(.empty, nil)
            return
        }

        var urlComponents = URLComponents(string: "\(apiBaseUrl)/\(tenantId)/func/verify")
        urlComponents?.queryItems = consents.sorted(by: { $0.key <= $1.key }).map { (key, value) in
            return URLQueryItem(name: key, value: "\(value)")
        }

        guard let url = urlComponents?.url else {
            Logger.log("Consents status verification url could not be constructed! Used consents: \(consents)", level: .error)
            completion(.invalid, nil)
            return
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            guard let apiData = data,
                  let json = try? JSONSerialization.jsonObject(with: apiData, options: .allowFragments) as? [String: Any],
                  let rawStatus = json["status"] as? String else {
                Logger.log("Consents status from API could not be parsed!", level: .error)
                completion(nil, error)
                return
            }

            let status = ConsentsStatus(from: rawStatus)
            completion(status, nil)
        }

        task.resume()
    }
}
