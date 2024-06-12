//
//  UIViewController+FromNib.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable force_unwrapping

extension UIViewController {

    class func loadFromNib<T: UIViewController>(bundle: Bundle) -> T {
        let viewNib = UINib(nibName: "\(T.self)", bundle: bundle)
        let view = viewNib.instantiate(withOwner: nil, options: nil).first as? T

        return view!
    }
}

// swiftlint:enable force_unwrapping
