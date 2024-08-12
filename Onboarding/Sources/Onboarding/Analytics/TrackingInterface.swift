import Foundation

public protocol TrackingInterface {
    var log: (String, [String: Any]?) { get }
}
