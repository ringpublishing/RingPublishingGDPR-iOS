//
//  AppTrackingTransparencyView.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 08/02/2021.
//

import Foundation
import UIKit

/// Explanation view for App Tracking Transparency
class AppTrackingTransparencyView: UIView {

    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var notNowButton: UIButton!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var titleTextView: UITextView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var logoImageViewWidthConstraint: NSLayoutConstraint!

    private var realLogoSizeConstrainedToHeight: CGSize {
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

    private var uiConfig: RingPublishingGDPRUIConfig?
    private var attConfig: RingPublishingGDPRATTConfig?

    private var descriptionTextViewSizeForShrinking: CGSize?
    private var descriptionSrinkingAttemptsLimit = 5

    /// Proxy for parent view delegate
    weak var delegate: RingPublishingGDPRViewControllerDelegate?

    // MARK: Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        titleTextView.delegate = self
        descriptionTextView.delegate = self

        let linksAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .underlineColor: UIColor.systemBlue
        ]
        titleTextView.linkTextAttributes = linksAttributes
        descriptionTextView.linkTextAttributes = linksAttributes
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        adjustViewMargins()

        guard descriptionTextViewSizeForShrinking == nil
            || descriptionTextViewSizeForShrinking?.width != descriptionTextView.frame.width else { return }

        configureTexts(with: uiConfig, attConfig: attConfig)
        descriptionTextViewSizeForShrinking = descriptionTextView.frame.size
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            adjustViewMargins()
        }

        guard #available(iOS 12.0, *),
              traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }

        // Reconfigure texts as style (like bold) is lost when appearance changes
        configureTexts(with: uiConfig, attConfig: attConfig)
    }

    // MARK: Set up

    /// Configure internal views using RingPublishingGDPRUIConfig
    ///
    /// - Parameters:
    ///   - uiConfig: RingPublishingGDPRUIConfig
    ///   - attConfig: RingPublishingGDPRATTConfig
    func configure(with uiConfig: RingPublishingGDPRUIConfig, attConfig: RingPublishingGDPRATTConfig?) {
        self.uiConfig = uiConfig
        self.attConfig = attConfig

        configureButtons(with: uiConfig, attConfig: attConfig)
        configureLogo(with: uiConfig, attConfig: attConfig)
        configureTexts(with: uiConfig, attConfig: attConfig)
    }
}

// MARK: Private
private extension AppTrackingTransparencyView {

    // MARK: UI

    func configureButtons(with uiConfig: RingPublishingGDPRUIConfig, attConfig: RingPublishingGDPRATTConfig?) {
        let buttonFontSize = actionButton.titleLabel?.font.pointSize

        actionButton.titleLabel?.font = uiConfig.font.withSize(buttonFontSize ?? uiConfig.font.pointSize)
        actionButton.backgroundColor = uiConfig.themeColor
        actionButton.setTitleColor(uiConfig.buttonTextColor, for: .normal)
        actionButton.setTitle(attConfig?.attExplanationAllowButtonText, for: .normal)

        notNowButton.titleLabel?.font = uiConfig.font.withSize(buttonFontSize ?? uiConfig.font.pointSize)
        notNowButton.setTitle(attConfig?.attExplanationNotNowButtonText, for: .normal)
    }

    func configureLogo(with uiConfig: RingPublishingGDPRUIConfig, attConfig: RingPublishingGDPRATTConfig?) {
        logoImageView.image = attConfig?.brandLogoImage
        logoImageView.layoutIfNeeded()

        logoImageViewWidthConstraint.constant = realLogoSizeConstrainedToHeight.width
    }

    func configureTexts(with uiConfig: RingPublishingGDPRUIConfig?, attConfig: RingPublishingGDPRATTConfig?) {
        guard let uiConfig = uiConfig else { return }

        let textColor = UIColor(named: "ringPublishingGDPRLabel", in: Bundle.ringPublishingGDPRBundle, compatibleWith: nil)

        let titleFontSize = titleTextView.font?.pointSize
        let titleFont = uiConfig.font.withSize(titleFontSize ?? uiConfig.font.pointSize)
        titleTextView.attributedText = attConfig?.attExplanationTitle?.convertfromHTML(using: titleFont,
                                                                                        textColor: textColor)

        configureDescriptionText(attConfig?.attExplanationDescription, textColor: textColor, uiConfig: uiConfig)
    }

    func configureDescriptionText(_ text: String?,
                                  textColor: UIColor?,
                                  uiConfig: RingPublishingGDPRUIConfig?,
                                  desiredFontSize: CGFloat? = nil,
                                  attempt: Int = 0) {
        guard let fontSize = desiredFontSize ?? descriptionTextView.font?.pointSize,
              let descriptionFont = uiConfig?.font.withSize(fontSize) else { return }

        descriptionTextView.attributedText = text?.convertfromHTML(using: descriptionFont, textColor: textColor)
        descriptionTextView.layoutIfNeeded()

        // Check if we have to shrink description font
        let textViewSize = descriptionTextView.frame.size
        let expectedSize = descriptionTextView.sizeThatFits(CGSize(width: textViewSize.width, height: CGFloat(MAXFLOAT)))

        guard expectedSize.height > textViewSize.height, attempt <= descriptionSrinkingAttemptsLimit else { return }

        configureDescriptionText(text, textColor: textColor,
                                 uiConfig: uiConfig,
                                 desiredFontSize: fontSize - 1,
                                 attempt: attempt + 1)
    }

    func adjustViewMargins() {
        guard let appBounds = UIApplication.shared.keyWindow?.bounds, UIDevice.isDeviceInLandscape else {
            directionalLayoutMargins = .zero
            return
        }

        let inset = max(0, appBounds.width - appBounds.height) / 2
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
    }

    // MARK: Actions

    @IBAction func onNotNowButtonButtonTouch(_ sender: Any) {
        delegate?.ringPublishingGDPRViewControllerDidDismissAppTrackingTransparencyExplanation()
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
