import Foundation
import SwiftUI
import UIKit

public final class Onboarding {
    private let dismissAction: () -> Void
    private let source: OnboardingSource
    private let analyticsService: OnboardingAnalyticsService?

    public init(source: OnboardingSource,
                analyticsService: OnboardingAnalyticsService?,
                dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.analyticsService = analyticsService
        self.source = source
    }

    public lazy var viewController: UIViewController = {
        let viewModel = OnboardingContainerViewModel(
            onboardingService: OnboardingService(),
            source: source,
            analyticsService: analyticsService,
            dismissAction: dismissAction
        )
        let containerView = OnboardingContainerView(viewModel: viewModel)
        return UIHostingController(rootView: containerView)
    }()
}
