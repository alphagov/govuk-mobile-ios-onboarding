import Foundation
import SwiftUI

struct OnboardingSlideView: View {
    private var model: OnboardingSlide
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(model: OnboardingSlide) {
        self.model = model
    }

    var body: some View {
        ScrollView {
            VStack {
                if verticalSizeClass != .compact {
                    Image(decorative: model.image, bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 225, height: 225)
                        .padding([.bottom])
                }
                Text(model.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(Text(model.title))
                    .padding(.top, verticalSizeClass == .compact ? 32 : 0)
                Text(model.body)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(Text(model.body))
                    .padding([.top])
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingSlideView(
        model: OnboardingSlide(image: "onboarding_placeholder_screen_1",
                               title: "Get things done on the go",
                               body: "GAccess government services and information")
    )
}
