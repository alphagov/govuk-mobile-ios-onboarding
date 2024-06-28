import Foundation

public enum OnboardingType {
    case json(String)
    case model([OnboardingSlide])
}
