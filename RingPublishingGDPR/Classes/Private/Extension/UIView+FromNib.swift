//
//  UIView+FromNib.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable force_unwrapping

// MARK: FromNib
extension UIView {

    /// Return UIView instance loaded from nib
    ///
    /// - Returns: UIView
    static func loadFromNib<T: UIView>(bundle: Bundle) -> T {
        let viewNib = UINib(nibName: "\(T.self)", bundle: bundle)
        let view = viewNib.instantiate(withOwner: self, options: nil).first as? T

        return view!
    }
}
