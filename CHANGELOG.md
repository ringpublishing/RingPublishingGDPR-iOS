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


