import Foundation

public enum OnboardingType {
    case localJSON(String)
    case preFetched([OnboardingSlide])
}
