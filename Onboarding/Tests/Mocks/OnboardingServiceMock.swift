import Foundation
@testable import Onboarding

    class MockOnboardingService: OnboardingServiceInterface {
        func downloadData(onboardingType: OnboardingSource,
                          completionHandler: @escaping (Result<[OnboardingSlide], any Error>) -> Void) {
            switch onboardingType {
            case .json(let fileName):
                let data = loadJSON(filename: fileName)
                completionHandler(.success(data))
            case .model(let slides):
                completionHandler(.success(slides))
            }
        }

        private func loadJSON(filename: String) -> [OnboardingSlide] {
            guard  let  path  = Bundle.module.url(forResource: filename, withExtension: "json")
            else { fatalError() }

            do {
                let data = try Data(contentsOf: path)
                let decodedObject = try JSONDecoder().decode([OnboardingSlide].self, from: data)
                return decodedObject
            } catch {
                return []
            }
        }
    }

