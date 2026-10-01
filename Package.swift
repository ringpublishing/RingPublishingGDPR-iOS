// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RingPublishingGDPR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "RingPublishingGDPR",
            targets: ["RingPublishingGDPR"]
        ),
    ],
    targets: [
        .target(
            name: "RingPublishingGDPR",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RingPublishingGDPRTests",
            dependencies: ["RingPublishingGDPR"]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
