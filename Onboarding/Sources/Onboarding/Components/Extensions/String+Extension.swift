import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, bundle: .module, comment: self)
    }
}
