import Foundation
@testable import Onboarding

class MockOnboardingSlideProvider: OnboardingSlideProvider {

    var _receivedFetchSlidesCompletionHander:
    ((Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void)?
    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void
    ) {
        _receivedFetchSlidesCompletionHander = completion
    }

}
