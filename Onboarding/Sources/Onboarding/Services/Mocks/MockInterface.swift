import Foundation

// protocol MockInterface: AnyObject {
//    func loadJSON(filename: String) -> [OnboardingSlide]
// }
//
// extension MockInterface {
//    func loadJSON(filename: String) -> [OnboardingSlide] {
//        guard let resourceUrl = Bundle.module.url(
//          forResource: "OnboardingResponse",
//          withExtension: "json"
//        ) else {
//            return []
//        }
//        do {
//            let data = try Data(contentsOf: resourceUrl)
//            let decodedObject = try JSONDecoder().decode([OnboardingSlide].self, from: data)
//            return decodedObject
//        } catch {
//            return []
//        }
//    }
// }
