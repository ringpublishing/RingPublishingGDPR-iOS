//
//  AppDelegate.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 10/12/2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import UIKit
import RingPublishingGDPR

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()

    // MARK: Life cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Example

        // Module should be initialized as early as possible so it can check if user consents are up to date
        // or those have to be saved again (by showing consent form to the user)
        // It will make your vendor SDKs to be setup in proper consents state from the very beginning

        // First you should initialize RingPublishingGDPR module with following data:
        // - config: RingPublishingGDPRUIConfig
        // - delegate: your delegate implementation to react for module events

        // In RingPublishingGDPRConfig you have to provide:
        // - tenantId: unique identifier assigned to your organization
        // - brandName: unique identifier assigned for specific app/brand
        // - uiConfig: simple configuration class in order to style native views show from module
        // - attConfig: (Optional) configuration used to show explanation screen for Apple App Tracking Transparency
        // and display system alert asking for permission. This requires also entry in your .plist file for
        // NSUserTrackingUsageDescription key

        // In RingPublishingGDPRATTConfig (which is optional) you have to provide only boolean flag saying if support
        // for ATT should be enabled, but realistically you should provide all configuration options so explanation screen
        // in your app looks as expected. See demo below for an example & how this can look like in runtime.

        let appTrackingTransparencySupportEnabled = true
        let tenantId = "<YOUR_TENANT_ID>"
        let brandName = "<YOUR_BRAND_NAME>"

        let uiConfig = RingPublishingGDPRUIConfig(themeColor: .red,
                                                  buttonTextColor: .white,
                                                  font: .systemFont(ofSize: 10))

        let attConfig = RingPublishingGDPRATTConfig(appTrackingTransparencySupportEnabled: appTrackingTransparencySupportEnabled)
        attConfig.brandLogoImage = UIImage(named: "brandLogo")
        attConfig.explanationAllowButtonText = "Allow".uppercased()
        attConfig.explanationNotNowButtonText = "Not now".uppercased() // or nil if don't want to show second option
        attConfig.explanationTitle = "Allow <b>RingPublishing</b> to use your app and website activity?"
        attConfig.explanationDescription = """
            To provide a <b><i>better ads experience</i></b>, we need permission to use future activity that other apps and websites
            send us from this device.This won’t give us access to new types of information.
            <br><br>
            <i><a href="https://ringpublishing.com/">Learn more</a></i> about how we limit our use of your activity
            if you turn off this device setting, and related settings on <b>RingPublishing</b>.
        """

        let config = RingPublishingGDPRConfig(tenantId: tenantId,
                                              brandName: brandName,
                                              uiConfig: uiConfig,
                                              attConfig: attConfig)

        // In case you want to change default networking timeout, which is used for initial consents check and then for
        // CMP webview page load, you should override it before initialization.
        // Default value for timeout is 10 seconds

        RingPublishingGDPR.shared.networkingTimeout = 8

        // If you want to disable console logs output, you can change it

        RingPublishingGDPR.shared.consoleLogsEnabled = true

        // Then initialize SDK

        RingPublishingGDPR.shared.initialize(config: config, delegate: self)

        // If you want, you can also use alternative initialization method with additional parameter: forcedGDPRApplies

        // RingPublishingGDPR.shared.initialize(config: config, delegate: self, forcedGDPRApplies: true)

        // At this point you should wait for SDK callback to either show consents controller or resume your normal app start
        // You could, for example, show here your splash screen

        let splashController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
        window?.rootViewController = splashController

        window?.makeKeyAndVisible()

        return true
    }

    // MARK: Helpers

    func showRingPublishingGDPRController(openScreen: ConsentsFormScreen) {
        // Here you can get UIViewController to be presented from module:
        let consentController = RingPublishingGDPR.shared.ringPublishingGDPRViewController

        // Present controller
        window?.rootViewController = consentController

        // Tell to the controller which view you want to show at app start
        switch openScreen {
        case .welcome:
            // To be opened on fresh app or when list of vendors has changed
            consentController.showConsentsWelcomeScreen()
        case .settings:
            // To be opened from application settings
            consentController.showConsentsSettingsScreen()
        }
    }

    func showAppContent() {
        let demoController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ViewController")
        window?.rootViewController = demoController

        // Here you can check if user agreed for all available vendors
        let areVendorConsentsGiven = RingPublishingGDPR.shared.areVendorConsentsGiven

        guard areVendorConsentsGiven else { return }
        // From this moment consents are given

        // If you app uses SDK's from vendors, which are not part of the official TCF 2.0 vendor list
        // you can use this flag to check if you can enable / initialize them as user agreed for all vendors
    }
}

// MARK: RingPublishingGDPRDelegate

extension AppDelegate: RingPublishingGDPRDelegate {

    // MARK: Required methods

    func ringPublishingGDPRDoesNotNeedToUpdateConsents(_ ringPublishingGDPR: RingPublishingGDPR) {
        // This will be called when consent form does not have to be shown to the user, either again or because GDPR does not
        // apply in current context / country

        // At this point you can resume you app launch if you were waiting for SDK callback
        showAppContent()
    }

    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            shouldShowConsentsController viewController: RingPublishingGDPRViewController) {
        // This will be called when consent form should be shown again to the user, (for example when vendors list changed)

        // At this point it is reasonable to show form opened on welcome screen like on initial app start
        showRingPublishingGDPRController(openScreen: .welcome)
    }

    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            shouldHideConsentsController viewController: RingPublishingGDPRViewController) {
        // This will be called each time when user did send his consent form
        // At this point:
        // - all consents are stored in UserDefaults
        // - form can be closed by host application
        // - content of app can be shown
        showAppContent()
    }

    // MARK: Optional methods (ATT)

    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, didRequestToOpenUrl url: URL) {
        // In demo app we are just opening url in Safari - in your app you can show it inside you app navigation hierarchy

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func ringPublishingGDPRDidPresentATTExplanationScreen(_ ringPublishingGDPR: RingPublishingGDPR) {
        // In demo app we are just printing this information to console - in your app you can use this for analytics purpose

        print("DEMO - RingPublishingGDPR: didPresentATTExplanationScreen")
    }

    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            userSelectedATTExplanationOptionWithResult trackingAllowed: Bool) {
        // In demo app we are just printing this information to console - in your app you can use this for analytics purpose

        print("DEMO - RingPublishingGDPR: userSelectedATTExplanationOptionWithResult -> \(trackingAllowed)")
    }

    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR,
                            userSelectedATTAlertPermissionWithResult trackingAllowed: Bool) {
        // In demo app we are just printing this information to console - in your app you can use this for analytics purpose

        print("DEMO - RingPublishingGDPR: userSelectedATTAlertPermissionWithResult -> \(trackingAllowed)")
    }

    // MARK: Optional methods (Error)

    func ringPublishingGDPR(_ ringPublishingGDPR: RingPublishingGDPR, didEncounterError error: RingPublishingGDPRError) {
        // In demo app we are just printing this information to console - in your app you can use this for analytics purpose

        print("DEMO - RingPublishingGDPR: didEncounterError -> \(error)")
    }
}
