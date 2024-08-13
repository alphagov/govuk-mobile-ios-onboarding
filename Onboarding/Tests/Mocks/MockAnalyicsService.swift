import Foundation
@testable import Onboarding

class MockAnalyticsService:AnalyticsService {
    func track(_ trackable: TrackingInterface) { }
    
    
}
