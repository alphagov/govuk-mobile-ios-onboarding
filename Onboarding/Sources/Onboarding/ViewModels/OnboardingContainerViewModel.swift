import Foundation
import SwiftUI

  class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var primaryButtonTitle = "Continue"
    let skipButtonAcessibilityHint = "Skip onboarding"
    let lastButtonTitle: String = "Done"
    let skipButtonTitle: String = "Skip"
    @Published var onboardingSlidesCount: Int = 0
    private let onbaordingService: OnboardingServiceInterface
    private let dismissAction: () -> Void
    private let onboardingType: OnboardingType

    init(onboardingService: OnboardingServiceInterface = OnboardingService(),
         dismissAction: @escaping () -> Void,
         onboardingType: OnboardingType) {
        self.onbaordingService = onboardingService
        self.dismissAction = dismissAction
        self.onboardingType = onboardingType
        fetchOnboarding()
    }

    var actionButtonAccessibilityHint: String {
        isLastSlide ? "Finish onboarding" : "Go to the next slide"
    }

    func action() {
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

    func getActionButtonTitle() -> String {
        if onboardingSlidesCount - 1 == tabIndex {
            return lastButtonTitle
        } else {
             return primaryButtonTitle
        }
    }

    private func finishOnboarding() {
       self.dismissAction()
    }

     var isLastSlide: Bool {
        tabIndex == onboardingSlidesCount - 1 ? true : false
    }

    private func fetchOnboarding() {
        onbaordingService.downloadData(
            onboardingType: onboardingType,
            completionHandler: { [weak self] data in
                guard let self = self else { return }
                switch data {
                case .success(let onboardingSlides):
                    if onboardingSlides.count > 1 {
                        self.onboardingSlidesCount = onboardingSlides.count
                        DispatchQueue.main.async {
                            self.state = .loaded(onboardingSlides)
                        }
                    } else { self.finishOnboarding() }
                case .failure:
                    DispatchQueue.main.async {
                        self.finishOnboarding()
                    }
                }
            }
        )
    }
}

extension OnboardingContainerViewModel {
    enum State {
        case loading
        case loaded([OnboardingSlide])
    }
}
