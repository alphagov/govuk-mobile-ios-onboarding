import Foundation

struct OnbardingNavigationEvent: TrackingInterface {
    private let title: String

    init(title: String) {
        self.title = title
    }

    var log: (String, [String: Any]?) {
        return (EventType.navigation.rawValue, ["Slide": title])
    }

    enum EventType: String {
        case navigation
    }
}
