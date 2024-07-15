import Foundation
import SwiftUI

class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var slideCount: Int = 0
    let skipButtonTitle = "skipButtonTitle".localized()
    let skipButtonAcessibilityHint = "skipButtonAcessibilityHint".localized()

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
        return isLastSlide ?
        "actionButtonLastSlideAccessibilityHint".localized() :
        "actionButtonAccessibilityHint".localized()
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

    var primaryButtonTitle: String {
        return isLastSlide ?
        "lastButtonTitle".localized() :
        "primaryButtonTitle".localized()
    }

    private func finishOnboarding() {
        DispatchQueue.main.async {
            self.dismissAction()
        }
    }

    var isLastSlide: Bool {
        tabIndex == slideCount - 1 ? true : false
    }

     private func fetchOnboarding() {
        onboardingService.fetchSlides(
            source: source,
            completionHandler: { [weak self] slides in
                switch slides {
                case .success(let slides) where slides.count >= 1:
                    self?.slideCount = slides.count
                        self?.state = .loaded(slides)
                default:
                    self?.finishOnboarding()
                }
            }
        )
    }
}

extension OnboardingContainerViewModel {
    enum State: Equatable {
        case loading
        case loaded([OnboardingSlide])
    }
}
