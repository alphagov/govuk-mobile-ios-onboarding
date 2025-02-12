import Foundation
import SwiftUI
import UIKit

public final class Onboarding {
    private let source: OnboardingSource
    private let analyticsService: OnboardingAnalyticsService?
    private let completeAction: () -> Void
    private let dismissAction: () -> Void

    public init(source: OnboardingSource,
                analyticsService: OnboardingAnalyticsService?,
                completeAction: @escaping () -> Void,
                dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.source = source
        self.completeAction = completeAction
        self.dismissAction = dismissAction
    }

    public lazy var viewController: UIViewController = {
        let viewModel = OnboardingContainerViewModel(
            onboardingService: OnboardingService(),
            source: source,
            analyticsService: analyticsService,
            completeAction: completeAction,
            dismissAction: dismissAction
        )
        let containerView = OnboardingContainerView(viewModel: viewModel)
        return UIHostingController(rootView: containerView)
    }()
}
