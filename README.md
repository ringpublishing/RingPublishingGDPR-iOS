![RingPublishing](https://github.com/ringpublishing/RingPublishingGDPR-iOS/raw/master/ringpublishing_logo.jpg)

# RingPublishingGDPR

Module which collects and saves user's consent in accordance with the standard TCF2.0

## Documentation

The documentation can be found at [https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/index.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/index.html).

Integration tutorial:
[https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/howto/integrate-using-ios-sdk.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/howto/integrate-using-ios-sdk.html).

How consents are stored:
[https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/topics/consent-storage-using-ios-sdk.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/topics/consent-storage-using-ios-sdk.html).

Reference guide:
[https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/reference/gdpr-ios-sdk.html](https://developer.ringpublishing.com/Money/docs/GDPRConsentManager/reference/gdpr-ios-sdk.html).

## Requirements

- iOS 11.0+
- Xcode 11+
- Swift 5.1+

## Installation

### CocoaPods

`RingPublishingGDPR` is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'RingPublishingGDPR'
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
