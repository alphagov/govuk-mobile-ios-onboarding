import Foundation

struct OnboardingActionEvent: TrackingInterface {
    private var eventType: EventType

    init(eventType: EventType) {
        self.eventType = eventType
    }

    var log: (String, [String: Any]?) {
        switch eventType {
        case .nextSlide:
            return (EventType.nextSlide.rawValue, nil)
        case .done:
            return (EventType.done.rawValue, nil)
        case .skip:
            return (EventType.skip.rawValue, nil)
        }
    }

    enum EventType: String {
        case nextSlide = "continue"
        case done
        case skip
    }
}
