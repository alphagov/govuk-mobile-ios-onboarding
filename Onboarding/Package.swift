// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Onboarding",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Onboarding",
            targets: ["Onboarding"])
    ],
    dependencies: [
        .package(url: "https://github.com/govuk-one-login/mobile-ios-common", branch: "main"),
        .package(url: "https://github.com/govuk-one-login/mobile-ios-coordination", branch: "main")
    ],
    targets: [
        .target(
            name: "Onboarding",
            dependencies: [
                .product(name: "GDSCommon",
                         package: "mobile-ios-common"),
                .product(name: "Coordination",
                         package: "mobile-ios-coordination")
            ]
        ),
        .testTarget(
            name: "OnboardingTests",
            dependencies: ["Onboarding"])
    ]
)
