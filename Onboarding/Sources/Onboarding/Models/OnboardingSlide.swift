import Foundation
import UIKit

public struct OnboardingSlide: Codable,
                               Equatable {
    public let image: String
    public let title: String
    public let body: String
    public let name: String

    public init(image: String,
                title: String,
                body: String,
                name: String) {
        self.image = image
        self.title = title
        self.body = body
        self.name = name
    }
}
