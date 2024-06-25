import Foundation
import UIKit

public struct OnboardingSlideModel: Identifiable,
                                    Codable {
    public let id: String
    let image: String
    let title: String
    let description: String
}
