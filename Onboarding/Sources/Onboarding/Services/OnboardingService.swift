import Foundation

public protocol OnboardingServiceInterface {
    func downloadData(onboardingType: OnboardingType,
                      completionHandler: @escaping (Result<[OnboardingSlide], Error>) -> Void)
}

public class OnboardingService: OnboardingServiceInterface {
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

    private func loadJSON(filename: String) -> [OnboardingSlide] {
        guard let resourceUrl = Bundle.module.url(
          forResource: "OnboardingResponse",
          withExtension: "json"
        ) else {
            return []
        }
        do {
            let data = try Data(contentsOf: resourceUrl)
            let decodedObject = try JSONDecoder().decode([OnboardingSlide].self, from: data)
            return decodedObject
        } catch {
            return []
        }
    }

}
