import Foundation
import UIKit

protocol AccessibilityPoster {
    static func post(notification: UIAccessibility.Notification, argument: Any?)
}

extension UIAccessibility: AccessibilityPoster {}
