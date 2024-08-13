import Foundation

@testable import Onboarding

class MockAnalyticsService: AnalyticsService {

    var _trackOnboardingEventReceivedEvents: [OnboardingEvent] = []
    func trackOnboardingEvent(_ event: OnboardingEvent) {
        _trackOnboardingEventReceivedEvents.append(event)
    }

    var _trackOnboardingScreenReceivedScreens: [OnboardingScreen] = []
    func trackOnboardingScreen(_ screen: OnboardingScreen) {
        _trackOnboardingScreenReceivedScreens.append(screen)
    }
}
