import GDSCommon
import UIKit

final class PageControllerViewController: BaseViewController {
    private let viewModel: PageControllerViewModel
    private let stackView = UIStackView()
    private let buttonStack = UIStackView()
    private let primaryButton = RoundedButton()
    private let secondaryButton = SecondaryButton()

    private var pages: [UIViewController]

    private lazy var scrollView = UIScrollView(
        frame: CGRect(x: 0,
                      y: 0,
                      width: view.frame.width,
                      height: 300)
    )

    private let pageController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private var currentIndex: Int {
        guard let currentVC = pageController.viewControllers?.first else { return 0 }
        return pages.firstIndex(of: currentVC) ?? 0
    }

    init(viewModel: PageControllerViewModel) {
        self.viewModel = viewModel

        pages = viewModel.pages.map {
            PageViewController(viewModel: $0)
        }

        super.init(
            viewModel: viewModel as? BaseViewModel,
            nibName: nil,
            bundle: nil
        )
        pageControlAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        super.viewDidLoad()

        configPageController(pageController)
        configurePrimaryButton(primaryButton)
        configureSecondaryButton(secondaryButton)
        configureButtonStack(buttonStack)
        configMainStack(stackView)

        view.addSubview(stackView)

        configureConstraints()
    }

    private func configMainStack(_ stackView: UIStackView) {
        stackView.govUKConfig(
            views: [pageController.view, buttonStack],
            translatesAutoresizingMask: false
        )
        stackView.layoutMargins = .zero
        stackView.isLayoutMarginsRelativeArrangement = false
        stackView.spacing = 0
    }

    private func configPageController(_ pageController: UIPageViewController) {
        pageController.dataSource = self
        pageController.delegate = self
        self.addChild(pageController)
        if let firstPage = pages.first {
            pageController.setViewControllers(
                [firstPage],
                direction: .forward,
                animated: true
            )
        }

        let pageControl = pageController.view.subviews.first {
            $0 is UIPageControl
        }
        guard let pageControl else { return }
        let scale = 1.5
        pageControl.transform = CGAffineTransform.init(scaleX: scale, y: scale)
    }

    private func pageControlAppearance() {
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = .systemGray3
        appearance.currentPageIndicatorTintColor = .greenAccent
        let config = UIImage.SymbolConfiguration(font: .footnote)
        appearance.preferredIndicatorImage = UIImage(systemName: "circle.fill", withConfiguration: config)
    }

    private func configurePrimaryButton(_ button: RoundedButton) {
        button.setTitle(viewModel.primaryButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(primaryButtonAction), for: .touchUpInside)
        button.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        button.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    private func configureSecondaryButton(_ button: SecondaryButton) {
        button.setTitleColor(.greenAccent, for: .normal)
        button.setTitle(viewModel.secondaryButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(secondaryButtonAction), for: .touchUpInside)
    }

    private func configureButtonStack(_ stackView: UIStackView) {
        stackView.govUKConfig(
            views: [primaryButton, secondaryButton],
            translatesAutoresizingMask: false
        )
        stackView.distribution = .fillProportionally
        let margins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.layoutMargins = margins
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func goToPage(pageIndex: Int, animated: Bool) {
        let currentIndex = currentIndex
        guard pageIndex >= 0 && pageIndex < pages.count else { return }

        let forward = pageIndex > currentIndex

        pageController.setViewControllers(
            [pages[pageIndex]],
            direction: forward ? .forward : .reverse,
            animated: true
        )
    }

    @objc
    private func goToPage(_ sender: UIPageControl) {
        let index = sender.currentPage
        goToPage(pageIndex: index, animated: true)
    }

    @objc
    private func primaryButtonAction() {
        print("primary button tapped")
        let currentIndex = currentIndex
        if currentIndex < pages.count - 1 {
            goToPage(pageIndex: currentIndex + 1, animated: true)
        } else {
            completeFlow()
        }
        updateButtonTitles()
    }

    @objc
    private func secondaryButtonAction() {
        completeFlow()
    }

    private func completeFlow() {
        viewModel.dismissAction()
    }
}

extension PageControllerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        updateButtonTitles()

        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 &&
                pages.count > previousIndex else {
            return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        updateButtonTitles()

        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let vcPagesCount = pages.count


        guard vcPagesCount != nextIndex &&
                vcPagesCount > nextIndex else {
            return nil
        }

        return pages[nextIndex]
    }

    private func updateButtonTitles() {
        let currentIndex = currentIndex
        if pages.count - 1 == currentIndex {
            primaryButton.setTitle(viewModel.primaryButtonTitleLast, for: .normal)
            secondaryButton.setTitle(viewModel.secondaryButtonTitleLast?.value, for: .normal)
        } else {
            primaryButton.setTitle(viewModel.primaryButtonTitle, for: .normal)
            secondaryButton.setTitle(viewModel.secondaryButtonTitle, for: .normal)
        }
    }

    private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageController.viewControllers?.first,
              let firstViewControllerIndex = pages.firstIndex(of: firstViewController) else {
                return 0
        }

        return firstViewControllerIndex
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let currentIndex = currentIndex
        return currentIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
}

extension PageControllerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        updateButtonTitles()
    }
}

@available(iOS 17.0, *)
#Preview {
    let vm = OnboardingViewModel(
        dismissAction: {
            print("screen dismissed")
        }
    )

    let vc = PageControllerViewController(viewModel: vm)
    return vc
}
