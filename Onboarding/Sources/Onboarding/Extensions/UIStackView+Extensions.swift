import Foundation
import UIKit

extension UIStackView {
    func govUKConfig(views: [UIView],
                     translatesAutoresizingMask: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMask
        self.axis = .vertical
        self.spacing = 16
        self.layoutMargins = UIEdgeInsets.zero
        self.alignment = .fill
        self.distribution = .fill
        self.isLayoutMarginsRelativeArrangement = true
        views.forEach {
            addArrangedSubview($0)
        }
        self.layoutSubviews()
    }
}
