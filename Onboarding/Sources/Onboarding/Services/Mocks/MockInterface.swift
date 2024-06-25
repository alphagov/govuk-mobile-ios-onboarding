import Foundation

protocol MockInterface: AnyObject {
    func loadJSON(filename: String) -> [OnboardingSlideModel]
}

extension MockInterface {
    func loadJSON(filename: String) -> [OnboardingSlideModel] {
        guard let resourceUrl = Bundle.module.url(
          forResource: "OnboardingResponse",
          withExtension: "json"
        ) else {
            return []
        }
        do {
            let data = try Data(contentsOf: resourceUrl)
            let decodedObject = try JSONDecoder().decode([OnboardingSlideModel].self, from: data)
            return decodedObject
        } catch {
            return []
        }
    }
}
