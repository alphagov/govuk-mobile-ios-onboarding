import Foundation

public struct OnboardingEvent {
    public let name: String
    public let type: String
    public let text: String?
    public let additionalParams: [String: Any?]?

    init(name: String,
         type: String,
         text: String?) {
        self.name = name
        self.type = type
        self.text = text
        self.additionalParams = [
            "external": false
        ]
    }
}

extension OnboardingEvent {
    static func buttonNavigation(text: String) -> OnboardingEvent {
        .init(
            name: "Navigation",
            type: "Button",
            text: text
        )
    }

    static var dotNavigation: OnboardingEvent {
        .init(
            name: "Navigation",
            type: "Dot",
            text: nil
        )
    }
}
