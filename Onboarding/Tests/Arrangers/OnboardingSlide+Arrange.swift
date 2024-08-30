import Foundation

@testable import Onboarding

extension OnboardingSlide {

    static func arrange(count: Int) -> [OnboardingSlide] {
        var slides: [OnboardingSlide] = []
        for index in 0...(count-1) {
            slides.append(.arrange(title: "slide_\(index)"))
        }
        return slides
    }

    static func arrange(image: String = UUID().uuidString,
                        title: String = UUID().uuidString,
                        body: String = UUID().uuidString,
                        name: String = UUID().uuidString) -> OnboardingSlide {
        .init(
            image: image,
            title: title,
            body: body,
            name: name
        )
    }

}
