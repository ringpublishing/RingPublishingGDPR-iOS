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
    @IBOutlet private weak var logoImageViewWidthConstraint: NSLayoutConstraint!

    /// Proxy for parent view delegate
    weak var delegate: RingPublishingGDPRViewControllerDelegate?

    // MARK: Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        titleTextView.delegate = self
        descriptionTextView.delegate = self
    }

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
        logoImageView.layoutIfNeeded()

        logoImageViewWidthConstraint.constant = getRealLogoSizeConstrainedToHeight().width
    }

    func getRealLogoSizeConstrainedToHeight() -> CGSize {
        guard let image = logoImageView.image, image.size.width > 0 && image.size.height > 0 else {
            return logoImageView.bounds.size
        }

        let scale = image.size.width > image.size.height ?
            logoImageView.bounds.width / image.size.width : logoImageView.bounds.height / image.size.height

        var size = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let heightLimitRatio = logoImageView.bounds.height / size.height
        size = CGSize(width: size.width * heightLimitRatio, height: size.height * heightLimitRatio)

        return size
    }

    func configureTexts(with uiConfig: RingPublishingGDPRUIConfig) {
        let textColor = UIColor(named: "ringPublishingGDPRLabel", in: Bundle.ringPublishingGDPRBundle, compatibleWith: nil)

        let titleFontSize = titleTextView.font?.pointSize
        let titleFont = uiConfig.font.withSize(titleFontSize ?? uiConfig.font.pointSize)
        titleTextView.attributedText = uiConfig.attOnboardingTitle?.convertfromHTML(using: titleFont,
                                                                                    textColor: textColor)

        let descriptionFontSize = descriptionTextView.font?.pointSize
        let descriptionFont = uiConfig.font.withSize(descriptionFontSize ?? uiConfig.font.pointSize)
        descriptionTextView.attributedText = uiConfig.attOnboardingDescription?.convertfromHTML(using: descriptionFont,
                                                                                                textColor: textColor)
    }

    // MARK: Actions

    @IBAction func onCancelButtonTouch(_ sender: Any) {
        delegate?.ringPublishingGDPRViewControllerDidDismissAppTrackingTransparencyOnboarding()
    }

    @IBAction func onActionButtonTouch(_ sender: Any) {
        delegate?.ringPublishingGDPRViewControllerDidRequestToShowAppTrackingTransparency()
    }
}

// MARK: UITextViewDelegate
extension AppTrackingTransparencyView: UITextViewDelegate {

    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        delegate?.ringPublishingGDPRViewControllerDidRequestToOpenURL(URL)

        return false
    }
}
