import Foundation
@testable import Onboarding

class MockAnalyticsService:AnalyticsService {
    
    var _events:[TrackingInterface] = []
    func track(_ trackable: TrackingInterface) {
        _events.append(trackable)
    }
}
