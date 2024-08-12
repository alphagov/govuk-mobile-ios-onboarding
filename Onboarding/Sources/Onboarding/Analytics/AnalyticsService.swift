import Foundation

public protocol AnalyticsService {
    func track(_ trackable: TrackingInterface)
}
