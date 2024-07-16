import Foundation
import SwiftUI

class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var slideCount: Int = 0
    let skipButtonTitle = NSLocalizedString(
        key: "skipButtonTitle",
        bundle: .module
    )
    let skipButtonAcessibilityHint = NSLocalizedString(
        key: "skipButtonAcessibilityHint",
        bundle: .module
    )
    private let onboardingService: OnboardingServiceInterface
    private let source: OnboardingSource
    private let dismissAction: () -> Void

    init(onboardingService: OnboardingServiceInterface,
         source: OnboardingSource,
         dismissAction: @escaping () -> Void) {
        self.onboardingService = onboardingService
        self.source = source
        self.dismissAction = dismissAction
        fetchOnboarding()
    }

    var actionButtonAccessibilityHint: String {
        isLastSlide ?
        NSLocalizedString(
            key: "actionButtonLastSlideAccessibilityHint",
            bundle: .module
        ) :
        NSLocalizedString(
            key: "actionButtonAccessibilityHint",
            bundle: .module
        )
    }

    func primaryAction() {
        if isLastSlide {
            finishOnboarding()
        } else {
            navigateToNextSlide()
        }
    }

    private func navigateToNextSlide() {
        tabIndex += 1
    }

    func skip() {
        finishOnboarding()
    }

    var primaryButtonTitle: String {
        isLastSlide ?
        NSLocalizedString(
            key: "lastButtonTitle",
            bundle: .module
        ) :
        NSLocalizedString(
            key: "primaryButtonTitle",
            bundle: .module
        )
    }

    private func finishOnboarding() {
        dismissAction()
    }

    var isLastSlide: Bool {
        tabIndex == slideCount - 1
    }

     private func fetchOnboarding() {
        onboardingService.fetchSlides(
            source: source,
            completionHandler: { [weak self] result in
                self?.handleSlidesResponse(result: result)
            }
        )
    }

    private func handleSlidesResponse(result: Result<[OnboardingSlide], Error>) {
        switch result {
        case .success(let slides) where slides.count >= 1:
            slideCount = slides.count
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
