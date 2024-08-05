import Foundation

public enum OnboardingSource {
    case json(String, Bundle = .main)
    case model([OnboardingSlide])
}
