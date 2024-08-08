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
            VStack(spacing: 0) {
                TabView(selection: $viewModel.tabIndex) {
                    ForEach(0..<onboardingSlides.count, id: \.self) { index in
                        OnboardingSlideView(model: onboardingSlides[index]).onAppear {
                            viewModel.trackNavigationEvent()
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                VStack(alignment: .center, spacing: 16) {
                    Divider()
                        .background(Color(UIColor.govUK.strokes.listDivider))
                        .ignoresSafeArea(edges: [.leading, .trailing])
                        .padding([.top], 0)
                    UIKitPageControl(
                        currentPage: $viewModel.tabIndex,
                        numberOfPages: viewModel.slideCount
                    )
                    AdaptiveStack(spacing: 0) {
                        SwiftUIButton(
                            .primary,
                            viewModel: viewModel.primaryButtonViewModel
                        )
                        .accessibilityHint(viewModel.actionButtonAccessibilityHint)
                        .accessibility(sortPriority: 1)
                        .frame(
                            minHeight: 44,
                            idealHeight: 44
                        )
                        if shouldShowSecondaryButton {
                            SwiftUIButton(
                                .secondary,
                                viewModel: viewModel.secondaryButtonViewModel
                            )
                            .accessibilityHint(viewModel.skipButtonAcessibilityHint)
                            .accessibility(sortPriority: 0)
                            .frame(
                                minHeight: 44,
                                idealHeight: 44
                            )
                            .opacity(viewModel.isLastSlide ? 0 : 1)
                        }
                    }
                    .padding([.leading, .trailing], verticalSizeClass == .regular ? 16 : 0)
                }
            }
            .accessibilityElement(children: .contain)
            .animation(.easeIn, value: viewModel.tabIndex)
        }
    }

    private var shouldShowSecondaryButton: Bool {
        verticalSizeClass == .regular ||
        viewModel.isLastSlide == false
    }
}
#Preview {
    let viewModel = OnboardingContainerViewModel(
        onboardingService: OnboardingService(),
        source: .model([]), tracker: OnboardingSlideTracker(),
        dismissAction: {}
    )
    viewModel.state = .loaded([OnboardingSlide(
        image: "onboarding_placeholder_screen_3",
        title: "Get things done on the go!",
        body: "Access government services and information on your phone using the GOV.UK app", alias: "")]
    )
    return OnboardingContainerView(
        viewModel: viewModel
    )
}
