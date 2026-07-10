//
//  RingPublishingGDPRATTConfig.swift
//  RingPublishingGDPR
//
//  Created by Adam Szeremeta on 16/02/2021.
//

import Foundation
import UIKit

/// RingPublishingGDPR module configuration used for App Tracking Transparency explanation screen & Apple ATT
public class RingPublishingGDPRATTConfig: NSObject {

    /// Should Apple App Tracking Transparency permission alert be shown after GDPR consents screen?
    ///
    /// If this option is enabled, texts for explanation (screen before apple alert is shown) should be provided
    @objc public let appTrackingTransparencySupportEnabled: Bool

    /// Brand logo image which can be shown on App Tracking Transparency explanation screens
    @objc public var brandLogoImage: UIImage?

    /// Text which will be displayed as title for App Tracking Transparency explanation screen
    ///
    /// This can be plain text or text with HTML attributes.
    @objc public var explanationTitle: String?

    /// Text which will be displayed as description for App Tracking Transparency explanation screen
    ///
    /// This can be plain text or text with HTML attributes.
    @objc public var explanationDescription: String?

    /// Text which will be displayed as "cancel" / "not now" button for App Tracking Transparency explanation screen
    /// If nil is passed or value is not set, this button will be hidden in UI
    @objc public var explanationNotNowButtonText: String?

    /// Text which will be displayed as "allow" / "continue" button for App Tracking Transparency explanation screen
    @objc public var explanationAllowButtonText: String?

    // MARK: Optional styling overrides (App Tracking Transparency explanation screen)
    //
    // All properties below are opt-in. When left `nil` the screen renders exactly as before
    // (values baked into the bundled xib), so existing integrations are unaffected.

    /// Corner radius applied to the "allow" / "continue" action button.
    ///
    /// When `nil`, the default value from the xib is used. The value is clamped to half of the
    /// button height at layout time, so passing a large value (e.g. a very big number) yields a
    /// fully rounded "capsule" button regardless of its height.
    public var actionButtonCornerRadius: CGFloat?

    /// Horizontal margin (in points) between the screen edges and its content
    /// (logo, texts and buttons).
    ///
    /// When `nil`, the default value from the xib is used.
    public var contentHorizontalMargin: CGFloat?

    /// Base font size (in points) used for the explanation description text.
    ///
    /// When `nil`, the default value from the xib is used. The description may still be shrunk
    /// automatically if it does not fit the available space.
    public var descriptionFontSize: CGFloat?

    /// Layout of the content (logo and texts) on the App Tracking Transparency explanation screen.
    ///
    /// Defaults to `.topLeft`, which matches the layout used by previous SDK versions.
    /// See `ContentAlignment` for the available layouts.
    public var contentAlignment: ContentAlignment = .topLeft

    // MARK: Init

    /// Initializer
    /// 
    /// - Parameter appTrackingTransparencySupportEnabled: Should Apple App Tracking Transparency permission alert
    ///     be shown after GDPR consents screen?
    @objc
    public init(appTrackingTransparencySupportEnabled: Bool) {
        self.appTrackingTransparencySupportEnabled = appTrackingTransparencySupportEnabled
    }
}
