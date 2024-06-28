// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import UIKit

public final class Onboarding {
    private let dismissAction: () -> Void

    public init(dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
    }

    public func initialViewController(for onboardingType: OnboardingType) -> UIViewController {
        UIHostingController(rootView: OnboardingContainerView(
            viewModel: OnboardingViewModel(dismissAction: dismissAction,
                                           onboardingType: onboardingType))
        )
    }
}
