import Foundation
import SwiftUI
import UIComponents

struct OnboardingContainerView: View {
    @StateObject private var viewModel: OnboardingContainerViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: OnboardingContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let layout = verticalSizeClass == .compact ?
        AnyLayout(HStackLayout()) :
        AnyLayout(VStackLayout())
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let viewModels):
            VStack(spacing: 0) {
                TabView(selection: $viewModel.tabIndex) {
                    ForEach(0..<viewModels.count, id: \.self) { index in
                        OnboardingSlideView(viewModel: viewModels[index]).onAppear {
                            viewModel.trackSlideView()
                        }
                    }
                }
                .onAppear {
                    viewModel.callAnimation(index: 0)
                }.animation(.easeIn, value: viewModel.tabIndex)
                    .onChange(
                        of: viewModel.tabIndex,
                        perform: { newValue in
                            withAnimation {
                                viewModel.callAnimation(index: newValue)
                            }
                        }
                    )
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .accessibilityIdentifier("container.tabview")
                VStack(alignment: .center, spacing: 16) {
                    Divider()
                        .background(Color(UIColor.govUK.strokes.listDivider))
                        .ignoresSafeArea(edges: [.leading, .trailing])
                        .padding([.top], 0)
                    if viewModel.slideCount > 1 {
                        UIKitPageControl(
                            currentPage: $viewModel.tabIndex,
                            numberOfPages: viewModel.slideCount,
                            didPressAction: { [weak viewModel] in
                                //                                viewModel?.trackPageControllerPressEvent()
                            }
                        )
                    }
                    layout {
                        SwiftUIButton(
                            .primary,
                            viewModel: viewModel.primaryButtonViewModel
                        )
                        //                        .accessibilityHint(viewModel.actionButtonAccessibilityHint)
                        .frame(
                            minHeight: 44,
                            idealHeight: 44
                        )
                        if shouldShowSecondaryButton {
                            SwiftUIButton(
                                .secondary,
                                viewModel: viewModel.secondaryButtonViewModel
                            )
                            //                            .accessibilityHint(viewModel.skipButtonAcessibilityHint)
                            .frame(
                                minHeight: 44,
                                idealHeight: 44
                            )
                            .opacity(shouldAlphaSecondaryButton ? 0 : 1)
                        }
                    }
                    .padding([.leading, .trailing], verticalSizeClass == .regular ? 16 : 0)
                }
            }
            .accessibilityElement(children: .contain)
            .animation(.easeIn, value: viewModel.tabIndex)
            .navigationBarHidden(true)
        }
    }

    private var shouldAlphaSecondaryButton: Bool {
        viewModel.isLastSlide && viewModel.slideCount > 1
    }

    private var shouldShowSecondaryButton: Bool {
        // Regular check here is to provide white space below continue
        verticalSizeClass == .regular ||
        viewModel.isLastSlide == false ||
        viewModel.slideCount == 1
    }
}

//#Preview {
//    let viewModel = OnboardingContainerViewModel(
//        onboardingService: OnboardingService(),
//        source: .model([]),
//        analyticsService: nil,
//        completeAction: {},
//        dismissAction: {}
//    )
//    viewModel.state = .loaded(
//        [
//            OnboardingSlide(
//                image: "onboarding_screen_3",
//                title: "Get things done on the go!",
//                body: "Access government services and information on your phone using the GOV.UK app",
//                name: ""
//            )
//        ]
//    )
//    return OnboardingContainerView(
//        viewModel: viewModel
//    )
//}
