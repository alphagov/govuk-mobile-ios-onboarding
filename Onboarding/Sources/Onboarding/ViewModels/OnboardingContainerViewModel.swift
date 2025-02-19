import Foundation
import SwiftUI
import UIComponents

class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var slideCount: Int = 0
    private var slides: [any OnboardingSlideViewModelInterface] = []
    private let slideProvider: OnboardingSlideProvider
    private let analyticsService: OnboardingAnalyticsService?
    private let accessibilityPoster: AccessibilityPoster.Type
    private let completeAction: () -> Void
    private let dismissAction: () -> Void

    init(slideProvider: OnboardingSlideProvider,
         analyticsService: OnboardingAnalyticsService?,
         accessibilityPoster: AccessibilityPoster.Type = UIAccessibility.self,
         completeAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.slideProvider = slideProvider
        self.accessibilityPoster = accessibilityPoster
        self.completeAction = completeAction
        self.dismissAction = dismissAction
        fetchOnboarding()
    }

    func didShow(index: Int) {
        let slide = slides[index]
        slide.didAppear()
        trackSlideView(slide: slide)
    }

    private func navigateToNextSlide() {
        tabIndex += 1
    }

    private func finishOnboarding() {
        completeAction()
    }

    private func trackSlideView(slide: any OnboardingSlideViewModelInterface) {
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

    var primaryButtonAccessibilityHint: String {
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

    var secondaryButtonAccessibilityHint: String {
        NSLocalizedString(
            "skipButtonAcessibilityHint",
            bundle: .module,
            comment: ""
        )
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let title = slides[tabIndex].primaryButtonTitle
        return .init(
            localisedTitle: title,
            action: { [weak self] in
                self?.trackButtonActionEvent(title: title)
                self?.primaryAction()
            }
        )
    }

    private func primaryAction() {
        if isLastSlide {
            finishOnboarding()
        } else {
            navigateToNextSlide()
            accessibilityPoster.post(notification: .screenChanged, argument: nil)
        }
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let title = slides[tabIndex].secondaryButtonTitle
        return .init(
            localisedTitle: title,
            action: { [weak self] in
                self?.trackButtonActionEvent(title: title)
                self?.dismissOnboarding()
            }
        )
    }

    private func fetchOnboarding() {
        slideProvider.fetchSlides(
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
            dismissOnboarding()
        }
    }

    func trackPageControllerPressEvent() {
        analyticsService?.trackOnboardingEvent(OnboardingEvent.dotNavigation)
    }

    private func trackButtonActionEvent(title: String) {
        let event = OnboardingEvent.buttonNavigation(text: title)
        analyticsService?.trackOnboardingEvent(event)
    }
}

extension OnboardingContainerViewModel {
    enum State {
        case loading
        case loaded([any OnboardingSlideViewModelInterface])
    }
}
