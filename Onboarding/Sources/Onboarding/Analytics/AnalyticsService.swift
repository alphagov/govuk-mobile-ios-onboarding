import Foundation

public protocol AnalyticsService {
    func trackOnboardingEvent(_ event: OnboardingEvent)
    func trackOnboardingScreen(_ screen: OnboardingScreen)
}
