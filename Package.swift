// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Onboarding",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Onboarding",
            targets: ["Onboarding"]
        ),
    ],
    targets: [
        .target(
            name: "Onboarding",
            path: "Onboarding",
            sources: [
                "Sources/Onboarding"
            ]
        ),
        .testTarget(
            name: "OnboardingTests",
            dependencies: ["Onboarding"],
            path: "Onboarding",
            sources: [
                "Tests/Specs",
                "Tests/Mocks"
            ],
            resources : [.process("Tests/Resources")]
        ),
    ]
)
