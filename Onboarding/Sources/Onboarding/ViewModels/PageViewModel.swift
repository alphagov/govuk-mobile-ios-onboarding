import GDSCommon
import UIKit

protocol PageViewModel {
    var title: GDSLocalisedString { get }
    var body: GDSLocalisedString { get }
    var image: UIImage { get }
}

struct OnboardingPrototypeWarningViewModel: PageViewModel {
    let title: GDSLocalisedString = "onboardingPrototypeWarningTitle"
    let body: GDSLocalisedString = "onboardingPrototypeWarningBody"
    let image: UIImage = UIImage(
        resource: .init(
            name: "onboarding_prototype",
            bundle: .module
        )
    )
}

struct OnboardingAccessDocumentsViewModel: PageViewModel {
    let title: GDSLocalisedString = "onboardingScreenAccessDocumentsTitle"
    let body: GDSLocalisedString = "onboardingScreenAccessDocumentsBody"
    let image: UIImage = UIImage(
        resource: .init(
            name: "onboarding_wallet",
            bundle: .module
        )
    )
}

struct OnboardingStayInformedViewModel: PageViewModel {
    let title: GDSLocalisedString = "onboardingStayInformedTitle"
    let body: GDSLocalisedString = "onboardingStayInformedBody"
    let image: UIImage = UIImage(
        resource: .init(
            name: "onboarding_notifications",
            bundle: .module
        )
    )
}

struct OnboardingGetThingsDoneViewModel: PageViewModel {
    let title: GDSLocalisedString = "onboardingGetThingsDoneTitle"
    let body: GDSLocalisedString = "onboardingGetThingsDoneBody"
    let image: UIImage = UIImage(
        resource: .init(
            name: "onboarding_services",
            bundle: .module
        )
    )
}
