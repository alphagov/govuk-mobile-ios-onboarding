import Foundation
import SwiftUI
import UIKit

public final class OnboardingModule {
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
