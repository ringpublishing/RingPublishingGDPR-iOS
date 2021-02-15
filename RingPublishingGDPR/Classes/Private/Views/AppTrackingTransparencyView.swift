//
//  AppTrackingTransparencyView.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 08/02/2021.
//

import Foundation
import UIKit

/// "Onboarding" view for App Tracking Transparency
class AppTrackingTransparencyView: UIView {

    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var titleTextView: UITextView!
    @IBOutlet private weak var logoImageView: UIImageView!

    /// Proxy for parent view delegate
    weak var delegate: RingPublishingGDPRViewControllerDelegate?

    // MARK: Set up

    /// Configure internal views using RingPublishingGDPRUIConfig
    ///
    /// - Parameters:
    ///   - uiConfig: RingPublishingGDPRUIConfig
    func configure(with uiConfig: RingPublishingGDPRUIConfig) {
        configureButtons(with: uiConfig)
        configureLogo(with: uiConfig)
        configureTexts(with: uiConfig)
    }
}

// MARK: Private
private extension AppTrackingTransparencyView {

    // MARK: UI

    func configureButtons(with uiConfig: RingPublishingGDPRUIConfig) {
        let buttonFontSize = actionButton.titleLabel?.font.pointSize

        actionButton.titleLabel?.font = uiConfig.font.withSize(buttonFontSize ?? uiConfig.font.pointSize)
        actionButton.backgroundColor = uiConfig.themeColor
        actionButton.setTitleColor(uiConfig.buttonTextColor, for: .normal)
        actionButton.setTitle(uiConfig.attOnboardingAllowButtonText, for: .normal)

        cancelButton.titleLabel?.font = uiConfig.font.withSize(buttonFontSize ?? uiConfig.font.pointSize)
        cancelButton.setTitle(uiConfig.attOnboardingCancelButtonText, for: .normal)
    }

    func configureLogo(with uiConfig: RingPublishingGDPRUIConfig) {
        logoImageView.image = uiConfig.brandLogoImage
    }

    func configureTexts(with uiConfig: RingPublishingGDPRUIConfig) {
        let textColor = UIColor(named: "ringPublishingGDPRLabel", in: Bundle.ringPublishingGDPRBundle, compatibleWith: nil)

        let titleFontSize = titleTextView.font?.pointSize
        let titleFont = uiConfig.font.withSize(titleFontSize ?? uiConfig.font.pointSize)
        titleTextView.attributedText = uiConfig.attOnboardingTitle?.convertfromHTML(using: titleFont, textColor: textColor)

        let descriptionFontSize = descriptionTextView.font?.pointSize
        let descriptionFont = uiConfig.font.withSize(descriptionFontSize ?? uiConfig.font.pointSize)
        descriptionTextView.attributedText = uiConfig.attOnboardingDescription?.convertfromHTML(using: descriptionFont, textColor: textColor)
    }

    // MARK: Actions

    @IBAction func onActionButtonTouch(_ sender: Any) {
        delegate?.ringPublishingGDPRViewControllerDidRequestToShowAppTrackingTransparency()
    }

    @IBAction func onCancelButtonTouch(_ sender: Any) {
        
    }
}
