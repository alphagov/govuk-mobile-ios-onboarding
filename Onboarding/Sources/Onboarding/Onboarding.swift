import Foundation
import SwiftUI
import UIKit

public final class Onboarding {
    private let slideProvider: OnboardingSlideProvider
    private let analyticsService: OnboardingAnalyticsService?
    private let completeAction: () -> Void
    private let dismissAction: () -> Void

    public init(slideProvider: OnboardingSlideProvider,
                analyticsService: OnboardingAnalyticsService?,
                completeAction: @escaping () -> Void,
                dismissAction: @escaping () -> Void) {
        self.slideProvider = slideProvider
        self.analyticsService = analyticsService
        self.completeAction = completeAction
        self.dismissAction = dismissAction
    }

    public lazy var viewController: UIViewController = {
        let viewModel = OnboardingContainerViewModel(
            slideProvider: slideProvider,
            analyticsService: analyticsService,
            completeAction: completeAction,
            dismissAction: dismissAction
        )
        let containerView = OnboardingContainerView(viewModel: viewModel)
        return UIHostingController(rootView: containerView)
    }()
}
