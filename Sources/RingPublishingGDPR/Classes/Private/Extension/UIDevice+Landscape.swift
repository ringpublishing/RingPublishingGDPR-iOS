//
//  UIDevice+Landscape.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 17/02/2021.
//

import Foundation
import UIKit

extension UIDevice {

    private static var lastKnownDeviceLandscapeStatus: Bool = false

    // MARK: Methods

    class var isDeviceInLandscape: Bool {
        var landscape = false

        defer {
            lastKnownDeviceLandscapeStatus = landscape
        }

        guard let orientation = UIApplication.keyWindow?.windowScene?.interfaceOrientation else { return landscape }

        if orientation != .unknown {
            landscape = orientation.isLandscape
        } else {
            // If device is flat on the table orientation is not returned (not portrait or landscape)
            landscape = lastKnownDeviceLandscapeStatus
        }

        return landscape
    }
}
