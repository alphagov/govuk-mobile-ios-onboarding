import Foundation
import SwiftUI
import UIComponents

struct OnboardingSlideView: View {
    private var model: OnboardingSlide
    @Environment(\.verticalSizeClass) var verticalSizeClass

    enum FocusableFields: Hashable {
        case title
        case body
    }

    @AccessibilityFocusState(for: .voiceOver)
    private var focus: FocusableFields?

    init(model: OnboardingSlide) {
        self.model = model
    }

    var body: some View {
        ScrollView {
            VStack {
                if verticalSizeClass == .regular {
                    Spacer(minLength: 32)
                }
                if verticalSizeClass != .compact {
                    Image(decorative: model.image, bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 225, height: 225)
                        .padding([.bottom])
                }
                    Text(model.title)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityLabel(Text(model.title))
                        .padding(.top, verticalSizeClass == .compact ? 32 : 0)
                        .padding([.trailing, .leading], 16)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityFocused($focus, equals: .title)
                    Text(model.body)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .multilineTextAlignment(.center)
                        .accessibilityLabel(Text(model.body))
                        .accessibilityFocused($focus, equals: .body)
                        .padding([.top, .leading, .trailing], 16)
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingSlideView(
        model: OnboardingSlide(
            image: "onboarding_screen_1",
            title: "Get things done on the go",
            body: "GAccess government services and information",
            name: ""
        )
    )
}
