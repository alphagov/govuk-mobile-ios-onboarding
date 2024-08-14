import Foundation

public protocol OnboardingAnalyticsService {
    func trackOnboardingEvent(_ event: OnboardingEvent)
    func trackOnboardingScreen(_ screen: OnboardingScreen)
}
