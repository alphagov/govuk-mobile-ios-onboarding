import Foundation
import UIKit

public struct OnboardingSlide: Codable,
                               Equatable {
    public let image: String
    public let title: String
    public let body: String
    public let alias: String

    public init(image: String,
                title: String,
                body: String,
                alias: String) {
        self.image = image
        self.title = title
        self.body = body
        self.alias = alias
    }
}
