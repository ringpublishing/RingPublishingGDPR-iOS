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
