//
//  GDPRManager+RingPublishingGDPRViewControllerDelegate.swift
//  RingPublishingGDPR
//
//  Created by Szeremeta Adam on 12.10.2020.
//  Copyright © 2020 Ringier Axel Springer Polska. All rights reserved.
//

import Foundation

// MARK: RingPublishingGDPRViewControllerDelegate

extension GDPRManager: RingPublishingGDPRViewControllerDelegate {

    func ringPublishingGDPRViewControllerDidRequestToShowWelcomeScreen() {
        detectUpdateFlowWithAppleAppTransparencyTracking(for: .showWelcomeScreen)
    }

    func ringPublishingGDPRViewControllerDidRequestToShowSetingsScreen() {
        detectUpdateFlowWithAppleAppTransparencyTracking(for: .showSettingsScreen)
    }

    func ringPublishingGDPRViewControllerDidRequestReload() {
        delegate?.gdprManager(self, isRequestingToChangeViewState: .loading)
        loadCMPSite()
    }

    func ringPublishingGDPRViewControllerDidDismissAppTrackingTransparencyExplanation() {
        Logger.log("AppTrackingTransparency - user selected 'not now' on explanation screen.")

        appTrackingManager.markExplanationAsShown()
        delegate?.gdprManager(self, userSelectedATTExplanationOptionWithResult: false)
        delegate?.gdrpManagerDidRequestToHideConsentsController(self)
    }

    func ringPublishingGDPRViewControllerDidRequestToShowAppTrackingTransparency() {
        Logger.log("AppTrackingTransparency - user selected 'allow' on explanation screen.")

        appTrackingManager.markExplanationAsShown()
        delegate?.gdprManager(self, userSelectedATTExplanationOptionWithResult: true)
        appTrackingManager.showAppTrackingTransparencyAlert { [weak self] trackingAllowed in
            guard let self = self else { return }

            Logger.log("AppTrackingTransparency consent received. Requesting to close view controller...")
            self.delegate?.gdprManager(self, userSelectedATTAlertPermissionWithResult: trackingAllowed)
            self.delegate?.gdrpManagerDidRequestToHideConsentsController(self)
        }
    }

    func ringPublishingGDPRViewControllerDidRequestToOpenURL(_ url: URL) {
        Logger.log("RingPublishingGDPRViewController is requesting to open URL (\(url.absoluteString)) selected by the user.")
        delegate?.gdprManager(self, isRequestingToOpenUrl: url)
    }
}

// MARK: Private
private extension GDPRManager {

    func detectUpdateFlowWithAppleAppTransparencyTracking(for action: GDPRAction) {
        // Detect if we have already stored GDPR consents but not Apple tracking consent
        // If this is such case we should only show Apple tracking agreement
        let shouldAppTrackingTransparencyBePresented = attConsentsNotDetermined && !gdprConsentsNotDetermined
        Logger.log("RingPublishingGDPRViewController starting consents flow, update to ATT? -> \(shouldAppTrackingTransparencyBePresented)")

        guard shouldAppTrackingTransparencyBePresented else {
            performAction(action)
            return
        }

        // We have stored GDPR consents - show only ATT view
        delegate?.gdprManager(self, isRequestingToChangeViewState: .appTrackingTransparency)
    }
}
