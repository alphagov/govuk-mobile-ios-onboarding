import Foundation
import SwiftUI

class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var slideCount: Int = 0
    private let nonFinalSlideprimaryButtonTitle = NSLocalizedString(
        "primaryButtonTitle",
        comment: ""
    )
    private let finalSlidePrimaryButtonTitle = NSLocalizedString(
        "lastButtonTitle",
        comment: ""
    )
    let skipButtonTitle = NSLocalizedString(
        "skipButtonTitle",
        comment: ""
    )
    let skipButtonAcessibilityHint = NSLocalizedString(
        "skipButtonAcessibilityHint",
        comment: ""
    )
    private let onboardingService: OnboardingServiceInterface
    private let dismissAction: () -> Void
    private let onboardingType: OnboardingSource

    init(onboardingService: OnboardingServiceInterface,
         onboardingType: OnboardingSource,
         dismissAction: @escaping () -> Void) {
        self.onboardingService = onboardingService
        self.onboardingType = onboardingType
        self.dismissAction = dismissAction
        fetchOnboarding()
    }

    var actionButtonAccessibilityHint: String {
        isLastSlide ?
        NSLocalizedString(
            "actionButtonLastSlideAccessibilityHint",
            comment: ""
        ) :
        NSLocalizedString(
            "actionButtonAccessibilityHint",
            comment: ""
        )
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
        if slideCount - 1 == tabIndex {
            return finalSlidePrimaryButtonTitle
        } else {
            return nonFinalSlideprimaryButtonTitle
        }
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
        onboardingService.downloadData(
            onboardingType: onboardingType,
            completionHandler: { [weak self] slides in
                switch slides {
                case .success(let slides) where slides.count >= 1:
                    self?.slideCount = slides.count
                    DispatchQueue.main.async {
                        self?.state = .loaded(slides)
                    }
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
