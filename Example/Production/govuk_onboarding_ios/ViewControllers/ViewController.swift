import UIKit
import Onboarding

class ViewController: UIViewController {

    private let analyticsService: OnboardingAnalyticsService?

    init(analyticsService: OnboardingAnalyticsService?) {
        self.analyticsService = analyticsService
        super.init()
    }

    required init?(coder: NSCoder) {
        self.analyticsService = nil
        super.init(coder: coder)
    }

    @IBAction private func showOnboarding(_ sender: Any) {

        let onboardingModule = Onboarding(
            slideProvider: TestOnboardingSlideProvider(),
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                self?.dismiss(animated: true)
            },
            dismissAction: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        onboardingModule.viewController.modalPresentationStyle = .fullScreen
        present(onboardingModule.viewController, animated: true)
    }
}

struct TestOnboardingSlideProvider: OnboardingSlideProvider {
    func fetchSlides(completion: @escaping OnboardingSlideProviderCompletion) {
        let json = loadJSON(filename: "OnboardingResponse")
        let slides = json.enumerated().map({
            OnboardingSlideImageViewModel(
                slide: $0.element,
                primaryButtonTitle: $0.offset == (json.count - 1) ? "Done": "Continue",
                primaryButtonAccessibilityHint: nil,
                secondaryButtonTitle: "Skip",
                secondaryButtonAccessibilityHint: nil
            )
        })
        completion(.success(slides))
    }

    private func loadJSON(filename: String) -> [OnboardingSlide] {
        let resourceUrl = Bundle.main.url(
            forResource: filename,
            withExtension: "json"
        )!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: resourceUrl)
        // swiftlint:disable:next force_try
        return try! JSONDecoder().decode([OnboardingSlide].self, from: data)
    }
}
