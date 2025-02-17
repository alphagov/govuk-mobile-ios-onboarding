import Foundation
import SwiftUI
import UIComponents

struct OnboardingSlideView: View {
    private var viewModel: any OnboardingSlideViewModelInterface
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private enum FocusableLabels: Hashable {
        case title
        case body
    }
    @AccessibilityFocusState(for: .voiceOver)
    private var focus: FocusableLabels?
    @State var contentView: AnyView

    init(viewModel: any OnboardingSlideViewModelInterface) {
        self.viewModel = viewModel
        self.contentView = viewModel.contentView
    }

    var body: some View {
        bouncableScrollView
            .onReceive(
                viewModel.contentViewPublisher,
                perform: { result in
                    self.contentView = result
                }
            )
    }

    private var bouncableScrollView: some View {
        if #available(iOS 16.4, *) {
            return scrollView
                .scrollBounceBehavior(.basedOnSize)
        } else {
            return scrollView
        }
    }

    private var scrollView: some View {
        ScrollView {
            VStack {
                if verticalSizeClass == .regular {
                    Spacer(minLength: 32)
                }
                if verticalSizeClass != .compact {
                    imageContainer
                }
                Text(viewModel.title)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityLabel(Text(viewModel.title))
                    .padding(.top, verticalSizeClass == .compact ? 32 : 0)
                    .padding([.trailing, .leading], 16)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityFocused($focus, equals: .title)
                Text(viewModel.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(Text(viewModel.body))
                    .accessibilityFocused($focus, equals: .body)
                    .padding([.top, .leading, .trailing], 16)
                Spacer()
            }.accessibilityElement(children: .contain)
        }
    }

    var imageContainer: some View {
        VStack {
            contentView
                .scaledToFit()
                .frame(width: 290, height: 290)
                .padding([.bottom])
        }
    }
}

//#Preview {
//    OnboardingSlideView(
//        model: OnboardingSlide(
//            image: "onboarding_screen_1",
//            title: "Get things done on the go",
//            body: "GAccess government services and information",
//            name: ""
//        )
//    )
//}
