import Foundation
import UIKit

final class PageViewController: UIViewController {
    let viewModel: PageViewModel
    let stackView = UIStackView()

    let spacer1 = UIView()
    let spacer2 = UIView()

    private lazy var image: UIView = {
        let uiView = UIView()
        let image = viewModel.image
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: uiView.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: uiView.heightAnchor)
        ])

        return uiView
    }()

    lazy var labelStack: UIStackView = {
        let stack = UIStackView(views: titleLabel, bodyLabel)
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 8
        return stack
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.title.value)"
        label.dynamicType(for: .largeTitleBold)
        label.textAlignment = .center
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.body.value)"
        label.dynamicType(for: .body)
        label.textAlignment = .center
        return label
    }()

    init(viewModel: PageViewModel) {
        spacer1.backgroundColor = .clear
        spacer2.backgroundColor = .clear
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupMainStack(stackView)
        configConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageViewController {
    func setupMainStack(_ stackView: UIStackView) {

        stackView.govUKConfig(
            views: [spacer1, image, spacer2, labelStack],
            translatesAutoresizingMask: false
        )
        stackView.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 16, right: 16)
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill

        view.addSubview(stackView)
    }

    func configConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spacer1.heightAnchor.constraint(lessThanOrEqualTo: spacer2.heightAnchor),
            image.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 75)
        ])
    }
}


@available(iOS 17.0, *)
#Preview {
    let vm = OnboardingPrototypeWarningViewModel()

    let vc = PageViewController(viewModel: vm)
    return vc
}
