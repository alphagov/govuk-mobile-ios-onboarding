import Foundation
import UIKit

@testable import Onboarding

struct MockAccessibilityPoster: AccessibilityPoster {
    static var _postParams: (UIAccessibility.Notification, Any?)? = nil

    static func post(notification: UIAccessibility.Notification, argument: Any?) {
        _postParams = (notification, argument)
    }
}
