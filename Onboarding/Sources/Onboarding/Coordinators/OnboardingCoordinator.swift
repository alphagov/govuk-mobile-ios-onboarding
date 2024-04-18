import Coordination
import UIKit

public final class OnboardingCoordinator: NSObject,
                                          AnyCoordinator,
                                          ChildCoordinator,
                                          NavigationCoordinator {
    public var parentCoordinator: ParentCoordinator?
    public let root: UINavigationController
    private let complete: () -> Void

    public init(parentCoordinator: ParentCoordinator?,
                root: UINavigationController = .init(),
                complete: @escaping () -> Void) {
        self.parentCoordinator = parentCoordinator
        self.complete = complete
        root.modalPresentationStyle = .overFullScreen
        root.navigationBar.isHidden = true
        self.root = root
    }

    public func start() {
        showWelcomeScreen()
    }

    private func showWelcomeScreen() {
        let viewModel = OnboardingViewModel(
            dismissAction: { [weak self] in
                self?.complete()
                self?.finish()
            }
        )

        let vc = PageControllerViewController(viewModel: viewModel)

        vc.isModalInPresentation = true
        vc.accessibilityViewIsModal = true

        root.pushViewController(vc, animated: false)
    }
}
