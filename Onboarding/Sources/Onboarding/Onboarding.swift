// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import UIKit

public final class Onboarding {
    private let dismissAction: () -> Void
    private let onboardingSource: OnboardingSource

    public init(dismissAction: @escaping () -> Void,
                onboardingSource: OnboardingSource) {
        self.dismissAction = dismissAction
        self.onboardingSource = onboardingSource
    }

    public lazy var viewController: UIViewController = {
        let viewModel = OnboardingContainerViewModel(
            onboardingService: OnboardingService(),
            dismissAction: dismissAction,
            onboardingType: self.onboardingSource
        )
        let containerView = OnboardingContainerView(viewModel: viewModel)
        return UIHostingController(rootView: containerView)
    }()
}
