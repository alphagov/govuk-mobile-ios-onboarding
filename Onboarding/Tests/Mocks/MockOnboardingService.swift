import Foundation
@testable import Onboarding

class MockOnboardingService: OnboardingServiceInterface {
 
    var _receivedDownloadDataOnboardingType: OnboardingSource?
    var _receivedDownloadDataCompletionHander: ((Result<[OnboardingSlide], any Error>) -> Void)?
    func downloadData(onboardingType: OnboardingSource,
                      completionHandler: @escaping (Result<[OnboardingSlide], any Error>) -> Void) {
        _receivedDownloadDataOnboardingType = onboardingType
        _receivedDownloadDataCompletionHander = completionHandler
    }

}
