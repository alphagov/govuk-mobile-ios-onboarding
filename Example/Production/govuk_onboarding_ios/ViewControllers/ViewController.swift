import UIKit
import Onboarding

class ViewController: UIViewController {

    @IBAction private func showOnboarding(_ sender: Any) {
        let onboarding = Onboarding(
            dismissAction: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        let onboardingViewController = onboarding.initialViewController(
            for: .json( "OnboardingResponse")
        )
        onboardingViewController.modalPresentationStyle = .fullScreen
        present(onboardingViewController, animated: true)
    }

}
