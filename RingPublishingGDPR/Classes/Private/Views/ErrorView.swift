//
//  ErrorView.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation
import UIKit

/// View displaying error info and retry button
class ErrorView: UIView {

    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorRetryButton: UIButton!

    /// Proxy for parent view delegate
    weak var delegate: RingPublishingGDPRViewControllerDelegate?

    // MARK: Life cycle

    public override func awakeFromNib() {
        super.awakeFromNib()

        loadTranslations()
    }

    // MARK: Set up

    /// Configure view using theme color, button color and font
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - buttonTextColor: UIColor
    ///   - font: UIFont
    func configure(withThemeColor color: UIColor, buttonTextColor: UIColor, font: UIFont) {
        errorRetryButton.layer.borderColor = color.cgColor
        errorRetryButton.setTitleColor(buttonTextColor, for: .normal)

        let attributedString = NSMutableAttributedString(string: errorLabel.text ?? "")
        let range = NSRange(location: 0, length: attributedString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.font, value: font.withSize(errorLabel.font.pointSize), range: range)
        errorLabel.attributedText = attributedString

        if let label = errorRetryButton.titleLabel {
            errorRetryButton.titleLabel?.font = font.withSize(label.font.pointSize)
        }
    }
}

// MARK: Private
private extension ErrorView {

    // MARK: Actions

    @IBAction func onRetryButtonTouch(_ sender: Any) {
        delegate?.ringPublishingGDPRViewControllerDidRequestReload()
    }

    // MARK: Translations

    /// Load translated texts into view
    func loadTranslations() {
        let bundle = Bundle.ringPublishingGDPRBundle

        errorLabel.text = NSLocalizedString("RingPublishingGDPR.errorView.errorNoInternet",
                                            tableName: nil,
                                            bundle: bundle,
                                            value: "",
                                            comment: "")
        let retryTitle = NSLocalizedString("RingPublishingGDPR.errorView.retryButton",
                                           tableName: nil,
                                           bundle: bundle,
                                           value: "",
                                           comment: "")
        errorRetryButton.setTitle(retryTitle, for: .normal)
    }
}
