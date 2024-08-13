import Foundation
import SwiftUI
import UIComponents

class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var slideCount: Int = 0
    private var trackingTitles: [String] = []
    let skipButtonTitle = NSLocalizedString(
        "skipButtonTitle",
        bundle: .module,
        comment: ""
    )
    let skipButtonAcessibilityHint = NSLocalizedString(
        "skipButtonAcessibilityHint",
        bundle: .module,
        comment: ""
    )
    private let onboardingService: OnboardingServiceInterface
    private let source: OnboardingSource
    private let analyticsService: OnboardingAnalyticsService?
    private let dismissAction: () -> Void

    init(onboardingService: OnboardingServiceInterface,
         source: OnboardingSource,
         analyticsService: OnboardingAnalyticsService?,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.onboardingService = onboardingService
        self.source = source
        self.dismissAction = dismissAction
        fetchOnboarding()
    }

    var actionButtonAccessibilityHint: String {
        isLastSlide ?
            NSLocalizedString(
                "actionButtonLastSlideAccessibilityHint",
                bundle: .module,
                comment: ""
            ) :
            NSLocalizedString(
                "actionButtonAccessibilityHint",
                bundle: .module,
                comment: ""
            )
    }

    func trackSlideView() {
        guard trackingTitles.count >= 1 else { return }
        let screen = OnboardingScreen(
            trackingName: trackingTitles[tabIndex],
            trackingClass: "OnboardingSlideView"
        )
        analyticsService?.trackOnboardingScreen(screen)
    }

    private func trackPrimaryActionEvent() {
        let event = OnboardingEvent(
            name: isLastSlide ? "done" : "continue",
            params: nil
        )
        analyticsService?.trackOnboardingEvent(event)
    }

    private func trackSecondaryActionEvent() {
        let event = OnboardingEvent(
            name: "skip",
            params: nil
        )
        analyticsService?.trackOnboardingEvent(event)
    }

    func primaryAction() {
        trackPrimaryActionEvent()
        if isLastSlide {
            finishOnboarding()
        } else {
            navigateToNextSlide()
        }
    }

    private func navigateToNextSlide() {
        tabIndex += 1
    }

    var primaryButtonTitle: String {
        isLastSlide ?
            NSLocalizedString(
                "lastButtonTitle",
                bundle: .module,
                comment: ""
            ) :
            NSLocalizedString(
                "primaryButtonTitle",
                bundle: .module,
                comment: ""
            )
    }

    private func finishOnboarding() {
        dismissAction()
    }

    var isLastSlide: Bool {
        tabIndex == slideCount - 1
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in self?.primaryAction() }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: skipButtonTitle,
            action: { [weak self] in
                self?.trackSecondaryActionEvent()
                self?.finishOnboarding()
            }
        )
    }

    private func fetchOnboarding() {
        onboardingService.fetchSlides(
            source: source,
            completionHandler: { [weak self] result in
                self?.handleSlidesResult(result: result)
            }
        )
    }

    private func handleSlidesResult(result: Result<[OnboardingSlide], Error>) {
        switch result {
        case .success(let slides) where slides.count >= 1:
            slideCount = slides.count
            trackingTitles = slides.map { $0.alias }
            state = .loaded(slides)
        default:
            finishOnboarding()
        }
    }
}

extension OnboardingContainerViewModel {
    enum State: Equatable {
        case loading
        case loaded([OnboardingSlide])
    }
}
