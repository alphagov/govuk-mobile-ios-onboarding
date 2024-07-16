import Foundation
@testable import Onboarding

class MockOnboardingService: OnboardingServiceInterface {
 
    var _receivedFetchSlidesSource: OnboardingSource?
    var _receivedFetchSlidesCompletionHander: ((Result<[OnboardingSlide], any Error>) -> Void)?
    func fetchSlides(source: OnboardingSource,
                     completionHandler: @escaping (Result<[OnboardingSlide], any Error>) -> Void) {
        _receivedFetchSlidesSource = source
        _receivedFetchSlidesCompletionHander = completionHandler
    }

}
