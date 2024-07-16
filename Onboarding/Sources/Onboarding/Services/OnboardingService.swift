import Foundation

protocol OnboardingServiceInterface {
    func fetchSlides(source: OnboardingSource,
                     completionHandler: @escaping (Result<[OnboardingSlide], Error>) -> Void)
}

class OnboardingService: OnboardingServiceInterface {
    func fetchSlides(source: OnboardingSource,
                     completionHandler: @escaping (Result<[OnboardingSlide], any Error>) -> Void) {
        switch source {
        case .json(let fileName, let bundle):
            let result = loadJSON(filename: fileName, bundle: bundle)
            completionHandler(result)
        case .model(let slides):
            completionHandler(.success(slides))
        }
    }

    private func loadJSON(filename: String, bundle: Bundle) -> Result<[OnboardingSlide], Error> {
        guard let resourceUrl = bundle.url(
          forResource: filename,
          withExtension: "json"
        ) else {
            return .failure(OnboardingServiceError.loadJsonError)
        }
        do {
            let data = try Data(contentsOf: resourceUrl)
            let decodedObject = try JSONDecoder().decode([OnboardingSlide].self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(error)
        }
    }
}

enum OnboardingServiceError: Error {
    case loadJsonError
}
