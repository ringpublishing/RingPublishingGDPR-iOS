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

        // First you should initialize RingPublishingGDPR module with following data:
        // - gdprApplies: true if GDPR applies in given context and consents form should be shown to the user
        // - tenantId: unique identifier assigned to your organization
        // - brandName: unique identifier assigned for specific app/brand
        // - uiConfig: simple configuration class in order to style native views show from module
        // - delegate: your delegate implementation to react for module events

        // Module should be initialized as early as possible so it can check if user consents are up to date
        // or those have to be saved again (by showing consent form to the user)
        // It will make your vendor SDKs to be setup in proper consents state from the very beginning

        let gdprApplies = true
        let supportsAppTrackingTransparency = true
        let tenantId = "<YOUR_TENANT_ID>"
        let brandName = "<YOUR_BRAND_NAME>"


        let config = RingPublishingGDPRConfig(gdprApplies: gdprApplies,
                                              tenantId: tenantId,
                                              brandName: brandName,
                                              supportsAppTrackingTransparency: supportsAppTrackingTransparency)
        let uiConfig = RingPublishingGDPRUIConfig(themeColor: .red,
                                                  buttonTextColor: .white,
                                                  font: .systemFont(ofSize: 10))
        uiConfig.brandLogoImage = UIImage(named: "brangLogo")
        uiConfig.attOnboardingAllowButtonText = "Allow".uppercased()
        uiConfig.attOnboardingCancelButtonText = "Not now".uppercased()
        uiConfig.attOnboardingTitle = "Allow <b>RingPublishing</b> to use your app and website activity?"
        uiConfig.attOnboardingDescription = """
            To provide a better ads experience, we need permission to use future activity that other apps and websites
            send us from this device.This won’t give us access to new types of information.
            <br><br>
            Learn more about how we limit our use of your activity if you turn off this device setting,
            and related settings on <b>RingPublishing</b>.
        """

        RingPublishingGDPR.shared.initialize(config: config,
                                             uiConfig: uiConfig,
                                             delegate: self)

        // At this point you can check if application should show consent form immediately at app launch
        // This covers use case when on this device user did not saw consent form yet and GDPR applies

        let shouldAskUserForConsents = RingPublishingGDPR.shared.shouldAskUserForConsents

        switch shouldAskUserForConsents {
        case false:
            // User already did see consent form - module will inform host application using delegate, if form
            // should be presented to the user again (for example when vendor list changed)

            // We can show application's content and initialize vendor SDKs
            showAppContent()

        case true:
            // User did not saw consent form yet - it should be shown to him immediately

            // Tell SDK that consent welcome screen should be shown
            // We can shown welcome screen or detailed view at start
            showRingPublishingGDPRController(openScreen: .welcome)
        }

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
        let demoController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
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
}
