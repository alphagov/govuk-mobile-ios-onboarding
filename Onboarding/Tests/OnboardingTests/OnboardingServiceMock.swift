import Foundation
@testable import Onboarding

    class MockOnboardingService: OnboardingServiceInterface {
        func downloadData(onboardingType: OnboardingSource,
                          completionHandler: @escaping (Result<[OnboardingSlide], any Error>) -> Void) {
            let slides:[OnboardingSlide] = [OnboardingSlide(image: "onboarding_placeholder_screen_1",
                                                            title: "Get things done on the go",
                                                            body: "Access government services and information on your phone using the GOV.UK app"),
                                            OnboardingSlide(image: "onboarding_placeholder_screen_2",
                                                            title: "Quickly get back to previous pages",
                                                            body: "Pages you’ve visited are saved so you can easily return to them"),
                                             OnboardingSlide(image: "onboarding_placeholder_screen_3",
                                                             title: "Tailored to you", 
                                                             body: "Choose topics that are relevant to you so you can find what you need faster")]
            completionHandler(.success(data))
        }

        private func loadJSON(filename: String) -> [OnboardingSlide] {
//            guard let testBundleAlt = Bundle.module.url(forResource: "MockOnboardingResponse", withExtension: "json")   else { fatalError() }
//           guard  let  path  = Bundle.module.url(forResource: filename, withExtension: "json") else { fatalError() }
            let data = loadJSON(filename: "MockOnboardingResponse")

            let testBundle = Bundle(for: type(of: self))
            guard let path = testBundle.url(forResource: filename, withExtension: "json")
                 else {
                    fatalError()
                    return []
                }
                do {
                    let data = try Data(contentsOf: path)
                    let decodedObject = try JSONDecoder().decode([OnboardingSlide].self, from: data)
                    return decodedObject
                } catch {
                    return []
                }
            return []
        }
    }

