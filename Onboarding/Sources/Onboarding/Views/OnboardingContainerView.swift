import Foundation
import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel: OnboardingContainerViewModel
    private var themeColor = Color("AccentColor", bundle: Bundle.module)
    private var textColor =  Color("PrimaryColor", bundle: Bundle.module)
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: OnboardingContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some  View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let onboardingSlides):
            VStack {
                TabView(selection: $viewModel.tabIndex) {
                    ForEach(0..<onboardingSlides.count, id: \.self) { index in
                        OnboardingSlideView(model: onboardingSlides[index])
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                UIKitPageControl(
                    currentPage: $viewModel.tabIndex,
                    numberOfPages: viewModel.slideCount
                )
                 .padding([.bottom])
                AdaptiveStack(spacing: 0) {
                    UIKitActionButton(
                        onTap: {
                            viewModel.action()
                        },
                        title: viewModel.primaryButtonTitle,
                        backgroundColor: themeColor,
                        textColor: textColor
                    )
                    .padding(.leading, verticalSizeClass == .compact ? nil :0)
                    .accessibilityLabel(
                        Text(viewModel.primaryButtonTitle)
                    )
                    .accessibilityHint(viewModel.actionButtonAccessibilityHint)
                    .accessibility(sortPriority: 1)
                    .frame(width: verticalSizeClass == .regular ? 383 : 424,
                           height: 44)
                    if (viewModel.isLastSlide == false &&
                        verticalSizeClass == .compact) ||
                        (viewModel.isLastSlide == false
                         && verticalSizeClass == .regular)
                        || (viewModel.isLastSlide == true &&
                            verticalSizeClass == .regular) {
                        UIKitSkipButton(
                            onTap: {
                                viewModel.skip()
                            },
                            title: viewModel.skipButtonTitle,
                            textColor: themeColor
                        )
                        .accessibilityHint(viewModel.skipButtonAcessibilityHint)
                        .accessibility(sortPriority: 0)
                        .frame(width: verticalSizeClass == .regular ? 375 : 424,
                               height: 44)
                        .opacity(viewModel.isLastSlide ? 0 : 1)
                    }
                }
                .accessibilityElement(children: .contain)
            }.animation(.easeIn, value: viewModel.tabIndex)
        }
    }
}
#Preview {
    let viewModel = OnboardingContainerViewModel(
        onboardingService: OnboardingService(),
        onboardingType: .model([]),
        dismissAction: {}
    )
    viewModel.state = .loaded([OnboardingSlide(
        image: "onboarding_placeholder_screen_3",
        title: "Get things done on the go!",
        body: "Access government services and information on your phone using the GOV.UK app")]
    )
    return OnboardingContainerView(
        viewModel: viewModel
    )
}
