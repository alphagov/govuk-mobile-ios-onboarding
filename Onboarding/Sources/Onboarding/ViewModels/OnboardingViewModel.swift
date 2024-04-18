import Foundation
import GDSCommon

struct OnboardingViewModel: PageControllerViewModel {
    let pages: [PageViewModel] = [
        OnboardingPrototypeWarningViewModel(),
        OnboardingAccessDocumentsViewModel(),
        OnboardingStayInformedViewModel(),
        OnboardingGetThingsDoneViewModel()
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

    func didDismiss() {
        dismissAction()
    }
}
