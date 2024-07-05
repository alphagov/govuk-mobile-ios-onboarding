import Foundation

protocol OnboardingServiceInterface {
    func fetchSlides(source: OnboardingSource,
                     completionHandler: @escaping (Result<[OnboardingSlide], Error>) -> Void)
}

class OnboardingService: OnboardingServiceInterface {
    func fetchSlides(source: OnboardingSource,
                     completionHandler: @escaping (Result<[OnboardingSlide], any Error>) -> Void) {
        switch source {
        case .json(let fileName):
            let data = loadJSON(filename: fileName)
            completionHandler(.success(data))
        case .model(let slides):
            completionHandler(.success(slides))
        }
    }

    private func loadJSON(filename: String) -> [OnboardingSlide] {
        guard let resourceUrl = Bundle.main.url(
          forResource: filename,
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
