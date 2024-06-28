import Foundation

public protocol OnboardingServiceInterface {
    func downloadData(onboardingType: OnboardingType,
                      completionHandler: @escaping (Result<[OnboardingSlide], Error>) -> Void)
}

public class OnboardingService: OnboardingServiceInterface,
                                MockInterface {
    public init() {}

    public func downloadData(onboardingType: OnboardingType,
                             completionHandler: @escaping (Result<[OnboardingSlide], any Error>) -> Void) {
        switch onboardingType {
        case .localJSON(let fileName):
            let data = loadJSON(filename: fileName)
            completionHandler(.success(data))
        case .preFetched(let slides):
            completionHandler(.success(slides))
        }
    }
}
