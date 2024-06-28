import UIKit
import Onboarding

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }

    func setUpViewController() {
        let onboardingModule =
        Onboarding(dismissAction: {})
        let onboardingViewController = onboardingModule.initialViewController(for: .json( "OnboardingResponse"))
        guard let onboardingView = onboardingViewController.view else { return }
        onboardingViewController.didMove(toParent: self)
        view.addSubview(onboardingViewController.view)
        setUpContraints(view: onboardingView)
    }

    private func setUpContraints(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                        multiplier: 1),
            view.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                         multiplier: 1),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
    }
}
