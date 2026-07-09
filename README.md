![RingPublishing](https://github.com/ringpublishing/RingPublishingGDPR-iOS/raw/master/ringpublishing_logo.jpg)

# RingPublishingGDPR

Module which collects and saves user's consent in accordance with the standard TCF2.0

## Documentation

The documentation can be found at:

[https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/index.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/index.html).

Integration tutorial:

[https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/howto/integrate-using-ios-sdk.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/howto/integrate-using-ios-sdk.html).

How consents are stored:

[https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/topics/consent-storage-using-mobile-sdk.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/topics/consent-storage-using-mobile-sdk.html).

Reference guide:

[https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/reference/gdpr-ios-sdk.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/reference/gdpr-ios-sdk.html).

## Requirements

- iOS 15.0+
- Xcode 16+
- Swift 5.1+

## Installation

### CocoaPods

`RingPublishingGDPR` is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following lines to your Podfile using our private Cocoapods Specs repository. Please make sure you have access to this repository granted by us.

Additions to your Podfile:
```ruby
source 'https://github.com/ringpublishing/RingPublishing-CocoaPods-Specs.git'

pod 'RingPublishingGDPR'
```

### Using [Swift Package Manager](https://swift.org/package-manager/)

To install it into a project, add it as a dependency within your project settings using Xcode:

```swift
Package URL: "https://github.com/ringpublishing/RingPublishingGDPR-iOS"
```

or if you are using manifest file, add it as a dependency there:

```swift
let Package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/ringpublishing/RingPublishingGDPR-iOS.git", .upToNextMinor(from: "1.8.1"))
    ],
    ...
)
```

## Usage

Start by importing `RingPublishingGDPR`:

```ruby
import RingPublishingGDPR
```

then you have access to shared module instance:

```ruby
RingPublishingGDPR.shared
```

For detailed example see demo project in `Example` directory or check our documentation.

## Customizing the App Tracking Transparency explanation screen

When App Tracking Transparency support is enabled, the SDK shows a native explanation screen before the system ATT prompt. Its content and appearance are configured through `RingPublishingGDPRATTConfig`:

```swift
let attConfig = RingPublishingGDPRATTConfig(appTrackingTransparencySupportEnabled: true)
attConfig.brandLogoImage = UIImage(named: "MyLogo")
attConfig.explanationTitle = "..."        // plain text or text with HTML attributes
attConfig.explanationDescription = "..."  // plain text or text with HTML attributes
attConfig.explanationAllowButtonText = "Allow"

// Optional styling. Every property below is opt-in — when left at its default value the
// screen renders exactly as in previous SDK versions, so existing integrations are unaffected.
attConfig.contentAlignment = .center          // .topLeft (default) or .center
attConfig.actionButtonCornerRadius = 24       // a large value yields a fully rounded "capsule" button
attConfig.contentHorizontalMargin = 16        // screen-edge inset for the logo, texts and buttons
attConfig.descriptionFontSize = 16            // base font size for the description text
```

`contentAlignment` controls the layout of the logo and texts on the explanation screen: `.topLeft` (the default) keeps them aligned to the leading edge, `.center` centers them horizontally.
