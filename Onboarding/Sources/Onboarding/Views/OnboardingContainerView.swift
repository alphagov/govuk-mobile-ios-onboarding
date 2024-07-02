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
                    numberOfPages: viewModel.onboardingSlidesCount
                )
                AdaptiveStack(spaceing: 0) {
                    UIKitActionButton(
                        onTap: {
                            viewModel.action()
                        },
                        title: viewModel.getActionButtonTitle(),
                        backgroundColor: themeColor,
                        textColor: textColor
                    )
                    .accessibilityLabel(
                        Text(viewModel.isLastSlide ? viewModel.lastButtonTitle:  viewModel.primaryButtonTitle)
                    )
                    .accessibilityHint(viewModel.actionButtonAccessibilityHint)
                    .accessibility(sortPriority: 1)
                    .frame(width: 383, height: 50)
                    UIKitSkipButton(
                        onTap: {
                            viewModel.skip()
                        },
                        title: viewModel.skipButtonTitle,
                        textColor: themeColor
                    )
                    .accessibilityLabel(Text(viewModel.skipButtonTitle))
                    .accessibilityHint(viewModel.skipButtonAcessibilityHint)
                    .accessibility(sortPriority: 0)
                    .frame(width: 375, height: 44)
                    .padding(.bottom)
                    .opacity(viewModel.isLastSlide ? 0 : 1)
                }
                .accessibilityElement(children: .contain)
            }.animation(.easeIn, value: viewModel.tabIndex)
        }
    }

    #Preview {
        OnboardingContainerView(
            viewModel: OnboardingContainerViewModel(onboardingService: OnboardingService(),
            dismissAction: {},
            onboardingType: .json( "OnboardingResponse"))
        )
    }
}
