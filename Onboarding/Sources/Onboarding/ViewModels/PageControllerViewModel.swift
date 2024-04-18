import GDSCommon
import UIKit

protocol PageControllerViewModel {
    var pages: [PageViewModel] { get }
    var primaryButtonTitle: GDSLocalisedString { get }
    var primaryButtonTitleLast: GDSLocalisedString { get }

    var secondaryButtonTitle: GDSLocalisedString { get }
    var secondaryButtonTitleLast: GDSLocalisedString? { get }

    var dismissAction: () -> Void { get }
}
