import UIKit
import Onboarding

class ViewController: UIViewController {

    private let analyticsService: AnalyticsService?

    init(analyticsService: AnalyticsService?) {
        self.analyticsService = analyticsService
        super.init()
    }

    required init?(coder: NSCoder) {
        self.analyticsService = nil
        super.init(coder: coder)
    }

    @IBAction private func showOnboarding(_ sender: Any) {
        let onboardingModule = Onboarding(
            source: .json("OnboardingResponse"),
            analyticsService: analyticsService,
            dismissAction: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        onboardingModule.viewController.modalPresentationStyle = .fullScreen
        present(onboardingModule.viewController, animated: true)
    }
}
