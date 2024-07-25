import Foundation
import SwiftUI
import UIComponents

struct OnboardingContainerView: View {
    @StateObject private var viewModel: OnboardingContainerViewModel
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
                Divider().ignoresSafeArea(edges: [.leading, .trailing])
                UIKitPageControl(
                    currentPage: $viewModel.tabIndex,
                    numberOfPages: viewModel.slideCount
                )
                .padding([.bottom])
                AdaptiveStack(spacing: 0) {
                    SwiftUIButton(
                        .primary,
                        viewModel: viewModel.primaryButtonViewModel
                    )
                    .padding(.leading, verticalSizeClass == .compact ? nil :0)
                    .accessibilityHint(viewModel.actionButtonAccessibilityHint)
                    .accessibility(sortPriority: 1)
                    .frame(minHeight: 44,
                           idealHeight: 44)
                    if (viewModel.isLastSlide == false &&
                        verticalSizeClass == .compact) ||
                        (viewModel.isLastSlide == false
                         && verticalSizeClass == .regular)
                        || (viewModel.isLastSlide == true &&
                            verticalSizeClass == .regular) {
                        SwiftUIButton(.secondary,
                                      viewModel: viewModel.secondaryButtonViewModel
                        )
                        .accessibilityHint(viewModel.skipButtonAcessibilityHint)
                        .accessibility(sortPriority: 0)
                        .frame(minHeight: 44,
                               idealHeight: 44)
                        .opacity(viewModel.isLastSlide ? 0 : 1)
                    }
                }
                .padding([.leading, .trailing], verticalSizeClass == .regular ? 16: 24)
            }.accessibilityElement(children: .contain)
                .animation(.easeIn, value: viewModel.tabIndex)
        }
    }
}
#Preview {
    let viewModel = OnboardingContainerViewModel(
        onboardingService: OnboardingService(),
        source: .model([]),
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
