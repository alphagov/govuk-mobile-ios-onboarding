import UIKit
import Onboarding

class ViewController: UIViewController {

    @IBAction private func showOnboarding(_ sender: Any) {
        let onboardingModule = Onboarding(
            source: .json("OnboardingResponse"),
            dismissAction: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        onboardingModule.viewController.modalPresentationStyle = .fullScreen
        present(onboardingModule.viewController, animated: true)
    }
}
