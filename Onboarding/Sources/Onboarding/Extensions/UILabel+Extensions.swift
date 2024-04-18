import Foundation
import UIKit

extension UILabel {
    func dynamicType(for font: UIFont,
                     alignment: NSTextAlignment = .left) {
        self.font = font
        self.numberOfLines = 0
        self.adjustsFontForContentSizeCategory = true
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = alignment
    }
}
