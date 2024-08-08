import Foundation
import SwiftUI
import UIKit

public final class Onboarding {
    private let dismissAction: () -> Void
    private let source: OnboardingSource

    public init(source: OnboardingSource,
                dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.source = source
    }

    public lazy var viewController: UIViewController = {
        let viewModel = OnboardingContainerViewModel(
            onboardingService: OnboardingService(),
            source: source, tracker: OnboardingSlideTracker(),
            dismissAction: dismissAction
        )
        let containerView = OnboardingContainerView(viewModel: viewModel)
        return UIHostingController(rootView: containerView)
    }()
}
