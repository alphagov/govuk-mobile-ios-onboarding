import Foundation
import UIKit

@testable import Onboarding

struct MockAccessibilityPoster: AccessibilityPoster {
    static var _receivedPostNotification: UIAccessibility.Notification? = nil

    static var _receivedPostArgument: Any? = nil

    static func post(notification: UIAccessibility.Notification, argument: Any?) {
        _receivedPostNotification = notification
        _receivedPostArgument = argument
    }
}
