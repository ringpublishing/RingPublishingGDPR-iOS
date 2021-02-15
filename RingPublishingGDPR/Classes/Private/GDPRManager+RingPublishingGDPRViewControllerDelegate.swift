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

    func ringPublishingGDPRViewControllerDidDismissAppTrackingTransparencyOnboarding() {
        appTrackingManager.markOnboardingAsShown()
        delegate?.gdrpManagerDidRequestToHideConsentsController(self)
    }

    func ringPublishingGDPRViewControllerDidRequestToShowAppTrackingTransparency() {
        appTrackingManager.markOnboardingAsShown()
        appTrackingManager.showAppTrackingTransparencyAlert { [weak self] in
            guard let self = self else { return }

            Logger.log("AppTrackingTransparency consent received. Requesting to close view controller...")
            self.delegate?.gdrpManagerDidRequestToHideConsentsController(self)
        }
    }
}

// MARK: Private
private extension GDPRManager {

    func detectUpdateFlowWithAppleAppTransparencyTracking(for action: GDPRAction) {
        // Detect if we have already stored GDPR consents but not Apple tracking consent
        // If this is such case we should only show Apple tracking agreement
        let isUpdateToAppTrackingTransparency = shouldAskUserForConsents && !gdprConsentsNotDetermined
        Logger.log("RingPublishingGDPRViewController reqesting to start consents flow, update to ATT? -> \(isUpdateToAppTrackingTransparency)")

        guard isUpdateToAppTrackingTransparency else {
            performAction(action)
            return
        }

        // We have stored GDPR consents - show only ATT view
        delegate?.gdprManager(self, isRequestingToChangeViewState: .appTrackingTransparency)
    }
}
