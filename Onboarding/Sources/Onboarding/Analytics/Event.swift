import Foundation

struct Event: TrackingInterface {
    var title: String
    var eventType: EventType
    var services: [EventServices]

    init(title: String, eventType: EventType) {
        self.title = title
        self.eventType = eventType
        services = {[.firebase(name: title,
                               params: [title: eventType.log])
        ]}()
    }

    enum EventType {
        case actionType(name: ActionType)
        case navigation
        var log: String {
            switch self {
            case .actionType(name: .done):
                return "Done"
            case .actionType(name: .skip):
                return "Skip"
            case .actionType(name: .nextSlide):
                return "Continue"
            case .navigation:
                return "navigation"
            }
        }
    }

    enum ActionType: String {
        case nextSlide = "continue"
        case done
        case skip
    }
}
