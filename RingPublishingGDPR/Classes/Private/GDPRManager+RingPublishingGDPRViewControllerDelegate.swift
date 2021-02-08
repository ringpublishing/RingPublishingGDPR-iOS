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
        performAction(.showWelcomeScreen)
    }

    func ringPublishingGDPRViewControllerDidRequestToShowSetingsScreen() {
        performAction(.showSettingsScreen)
    }

    func ringPublishingGDPRViewControllerDidRequestReload() {
        delegate?.gdprManager(self, isRequestingToChangeViewState: .loading)
        loadCMPSite()
    }
}
