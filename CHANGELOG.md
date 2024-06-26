1.8.0 Release notes (2024-06-11)
=============================================================

### Changes

* Added support for Swift Package Manager

1.7.1 Release notes (2023-12-22)
=============================================================

### Changes

* Added property 'consoleLogsEnabled' to 'RingPublishingGDPR.shared' as possibility to disable console logs output from module

1.7.0 Release notes (2023-10-16)
=============================================================

### Changes

* Added support for TCF2.2:
    - replaced 'UserDefaults' field: 'IABTCF_UseNonStandardStacks' with 'IABTCF_UseNonStandardTexts'

1.6.1 Release notes (2023-08-01)
=============================================================

### Changes

* Enhanced module logs with full 'Error' description from WkWebView and data like url loaded in WkWebView

1.6.0 Release notes (2021-12-13)
=============================================================

### Features

* Added optional 'ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, didEncounterError error: RingPublishingGDPRError)' method to 'RingPublishingGDPRDelegate' protocol
    - This method informs about something unexpected happening during "normal" consents state check
    - This is only returned for informational purpose and application does not need to handle it in any way

### Changes

* Removed deprecated 'class' protocols conformance in place of 'AnyObject'

1.5.0 Release notes (2021-06-23)
=============================================================

### Features

* Added support for optional parameter in module initializer: 'forcedGDPRApplies'.
    - If you want to ignore geo-ip based detection for 'gdprApplies', pass as 'forcedGDPRApplies' param either true of false. This parameter is optional.
* Added public module property: 'gdprApplies'. This contains information if GDPR applies in current context.
    - This property at module initialization (and before) has value saved from last app session.
    - This property will be populated with fresh value somewhere between:
        - after module initialization
        - before module calls one of the delegate methods with consents status, either 'shouldShowConsentsController' or 'doesNotNeedToUpdateConsents'

1.4.0 Release notes (2021-04-29)
=============================================================

### Features

* Added support for backend configuration (based on geo-ip) for 'gdprApplies' (IABTCF_gdprApplies) flag. This flag can no longer be passed as parameter to the SDK initializer.
* Interaction with module on app start is now always asynchronous (where previously during first app launch it was synchronous). SDK will always call one of two delegate methods after initialization:
    - 'ringPublishingGDPRDoesNotNeedToUpdateConsents(_ ringPublishingGDPR: RingPublishingGDPR)' if there is no need to show consents controller (for example ATT is disabled, gdprApplies is false, networking error during initialization, etc.)
    - 'ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, shouldShowConsentsController viewController: RingPublishingGDPRViewController)' if consents controller should be presenter to the user (for example when gdprApplies is true and consents are not stored on the device or are outdated)

### Changes

* Removed 'gdprApplies' property from 'RingPublishingGDPRConfig' interface
* Removed 'shouldAskUserForConsents' property from 'RingPublishingGDPR' interface
* Added required 'ringPublishingGDPRDoesNotNeedToUpdateConsents(_ ringPublishingGDPR: RingPublishingGDPR)' method to 'RingPublishingGDPRDelegate' protocol

1.3.2 Release notes (2021-03-28)
=============================================================

### Changes

* If you pass 'nil' for 'RingPublishingGDPRATTConfig.explanationNotNowButtonText' or don't set this at all, second button on ATT explanation screen will be hidden on UI

1.3.1 Release notes (2021-03-11)
=============================================================

### Bugfix

* Delayed Apple App Tracking Transparency explanation screen texts configuration to prevent WebKit crash. This could happen if texts were configured while app was still not in '.active' state. Now those texts will be set during view layout process or when app becomes active.

1.3.0 Release notes (2021-02-08)
=============================================================

### Features

* Added support for Apple App Tracking Transparency & explanation screen before system permission alert is shown.
* New config class: 'RingPublishingGDPRATTConfig' related to Apple App Tracking Transparency & explanation screen with following options:
    - appTrackingTransparencySupportEnabled
    - brandLogoImage
    - explanationTitle
    - explanationDescription
    - explanationNotNowButtonText
    - explanationAllowButtonText
* 'RingPublishingGDPRATTConfig' has only one initializer with required 'appTrackingTransparencySupportEnabled' property. Other properties are mutable and can be assigned to config class allowing easier customization.
* New optional delegate methods in 'RingPublishingGDPRDelegate' related to Apple App Tracking Transparency & explanation screen:
    - ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, didRequestToOpenUrl url: URL)
    - ringPublishingGDPRDidPresentATTExplanationScreen(_ ringPublishingGDPR: RingPublishingGDPR)
    - ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, userSelectedATTExplanationOptionWithResult trackingAllowed: Bool)
    - ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, userSelectedATTAlertPermissionWithResult trackingAllowed: Bool)

### Changes

* Module initialization parameters: 'gdprApplies', 'tenantId', 'brandName', 'RingPublishingGDPRUIConfig' moved to 'RingPublishingGDPRConfig' class.
* 'RingPublishingGDPR.shouldAskUserForConsents' flag takes into consideration App Tracking Transparency status if it is enabled in configuration.

1.2.0 Release notes (2020-11-19)
=============================================================

### Features

* Consents property removed from Public interface as they are for non-public usage only.
* New dictionary 'RingPublishing_PublicConsents' stored in user defaults (should be used for other purposes than Ad Server (public))

1.1.0 Release notes (2020-11-06)
=============================================================

Update adding support for "opt out" from consents form by providing initialization flag, that GDPR does not apply in current context.

### Features

* RingPublishingGDPR 'initialize' method now accepts additional parameter: 'gdprApplies'
* Immidiatelly after module initialization, in User Defaults are stored two properties:
   - 'IABTCF_CmpSdkID' with official CMP SDK ID
   - 'IABTCF_gdprApplies' with passed to module boolean flag if GDPR should apply

### Changes

* Removed: 'didAskUserForConsents' property
* Added: 'shouldAskUserForConsents' property which respects GDPR setting and stored consents. If 'gdprApplies' is false, this flag will return false.

1.0.1 Release notes (2020-10-29)
=============================================================

### Features

* Public interface has been extended about two additional properties "customConsents" and "areVendorConsentsGiven"
which can be used by other Ring Publishing modules, e.g. Ad Server.

1.0.0 Release notes (2020-10-12)
=============================================================

First 'RingPublishingGDPR' module release

### Features

* Collects and saves user's consent in accordance with the standard TCF2.0
https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details
* Has support for temporary Google’s Additional Consent
https://support.google.com/admanager/answer/9681920?hl=en
* Collects and saves 'internal' user's consent stored in UserDefaults with 'RingPublishing_' key prefixes


