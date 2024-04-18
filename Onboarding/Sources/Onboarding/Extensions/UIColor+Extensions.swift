import Foundation
import UIKit

extension UIColor {
    static let greenAccent = UIColor(.greenAccent)

    private convenience init(_ color: GOVUKColours) {
        self.init(
            named: color.rawValue,
            in: .module,
            compatibleWith: nil
        )!
    }

    enum GOVUKColours: String {
        case greenAccent
    }
}
