//
//  UIApplication+Window.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 01/10/2025.
//

import Foundation
import UIKit

extension UIApplication {

    class var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
