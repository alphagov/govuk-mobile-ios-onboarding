import Foundation
import SwiftUI
import UIComponents

class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var slideCount: Int = 0
    private var slides: [any OnboardingSlideViewModelInterface] = []
    let skipButtonTitle = "Skip"
    private let onboardingService: OnboardingSlideProvider
    private let analyticsService: OnboardingAnalyticsService?
    private let accessibilityPoster: AccessibilityPoster.Type
    private let completeAction: () -> Void
    private let dismissAction: () -> Void

    init(onboardingService: OnboardingSlideProvider,
         analyticsService: OnboardingAnalyticsService?,
         accessibilityPoster: AccessibilityPoster.Type = UIAccessibility.self,
         completeAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.onboardingService = onboardingService
        self.accessibilityPoster = accessibilityPoster
        self.completeAction = completeAction
        self.dismissAction = dismissAction
        fetchOnboarding()
    }

    func primaryAction() {
        if isLastSlide {
            finishOnboarding()
        } else {
            navigateToNextSlide()
            accessibilityPoster.post(notification: .screenChanged, argument: nil)
        }
    }

    func callAnimation(index: Int) {
        slides[index].startAnimation()
    }

    private func navigateToNextSlide() {
        tabIndex += 1
    }

    var primaryButtonTitle: String {
        isLastSlide ? "Continue" : "Next"
    }

    private func finishOnboarding() {
        completeAction()
    }

    func trackSlideView() {
        guard slides.count >= 1 else { return }
        let slide = slides[tabIndex]
        let screen = OnboardingScreen(
            trackingName: slide.name,
            trackingClass: "OnboardingSlideView",
            trackingTitle: slide.title
        )
        analyticsService?.trackOnboardingScreen(screen)
    }

    private func dismissOnboarding() {
        dismissAction()
    }

    var isLastSlide: Bool {
        tabIndex == slideCount - 1
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.primaryAction()
            }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: skipButtonTitle,
            action: { [weak self] in
                self?.dismissOnboarding()
            }
        )
    }

    private func fetchOnboarding() {
        onboardingService.fetchSlides(
            completion: { [weak self] result in
                self?.handleSlidesResult(result: result)
            }
        )
    }

    private func handleSlidesResult(result: Result<[any OnboardingSlideViewModelInterface], Error>) {
        switch result {
        case .success(let viewModels) where viewModels.count >= 1:
            self.slides = viewModels
            slideCount = viewModels.count
            state = .loaded(self.slides)
        default:
            finishOnboarding()
        }
    }
}

extension OnboardingContainerViewModel {
    enum State {
        case loading
        case loaded([any OnboardingSlideViewModelInterface])
    }
}
