import Foundation

public enum OnboardingSource {
    case json(String)
    case model([OnboardingSlide])
}
