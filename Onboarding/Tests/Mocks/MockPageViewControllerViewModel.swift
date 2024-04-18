import GDSCommon
import UIKit

@testable import Onboarding

struct MockPageViewModel: PageViewModel {
    let title: GDSLocalisedString = "Mock page"
    let body: GDSLocalisedString = "Mock body text"
    let image: UIImage = UIImage(systemName: "1.circle")!
}


struct MockPageControllerViewModel: PageControllerViewModel {
    let pages: [PageViewModel] = [
        MockPageViewModel(),
        MockPageViewModel(),
        MockPageViewModel()
    ]

    let primaryButtonTitle: GDSLocalisedString = "Continue"
    let primaryButtonTitleLast: GDSLocalisedString = "Done"

    let secondaryButtonTitle: GDSLocalisedString = "Skip"
    let secondaryButtonTitleLast: GDSLocalisedString? = nil

    let rightBarButtonTitle: GDSLocalisedString? = nil
    let backButtonIsHidden: Bool = true

    let dismissAction: () -> Void

    init(dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
    }
}
