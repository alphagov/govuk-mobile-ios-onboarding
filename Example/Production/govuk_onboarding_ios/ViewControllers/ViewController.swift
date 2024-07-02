import UIKit
import Onboarding

class ViewController: UIViewController {

    @IBAction private func showOnboarding(_ sender: Any) {
        let onboardingModule = Onboarding(dismissAction: { [weak self] in
            self?.dismiss(animated: true)
        }, onboardingSource: .json("OnboardingResponse"))
        onboardingModule.viewController.modalPresentationStyle = .fullScreen
        present(onboardingModule.viewController, animated: true)
    }
}
