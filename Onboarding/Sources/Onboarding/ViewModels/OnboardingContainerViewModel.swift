import Foundation
import SwiftUI

class OnboardingContainerViewModel: ObservableObject {
    @Published var tabIndex: Int = 0
    @Published var state = State.loading
    @Published var slideCount: Int = 0
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
    private let onboardingType: OnboardingSource
    private let dismissAction: () -> Void

    init(onboardingService: OnboardingServiceInterface,
         onboardingType: OnboardingSource,
         dismissAction: @escaping () -> Void) {
        self.onboardingService = onboardingService
        self.onboardingType = onboardingType
        self.dismissAction = dismissAction
        fetchOnboarding()
    }

    var actionButtonAccessibilityHint: String {
        let key = isLastSlide ?
        "actionButtonLastSlideAccessibilityHint" :
        "actionButtonAccessibilityHint"
        return NSLocalizedString(key, bundle: .module, comment: "")
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
        let key = isLastSlide ? "lastButtonTitle" : "primaryButtonTitle"
        return NSLocalizedString(key, bundle: .module, comment: "")
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
