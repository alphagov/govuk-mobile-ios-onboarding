import Foundation
import SwiftUI
import UIComponents

struct OnboardingSlideView: View {
    private var model: OnboardingSlide
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(model: OnboardingSlide) {
        self.model = model
    }

    var body: some View {
        ScrollView {
            VStack {
                if verticalSizeClass == . regular {
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
                    .foregroundColor(UIColor.govUK.text.primary.toColor())
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(Text(model.title))
                    .padding(.top, verticalSizeClass == .compact ? 32 : 0)
                    .padding([.trailing, .leading], 16)
                Text(model.body)
                    .foregroundColor(UIColor.govUK.text.primary.toColor())
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(Text(model.body))
                    .padding([.top, .leading, .trailing], 16)
                Spacer()
            }.accessibilityElement(children: .contain)
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

extension UIColor {
    // swiftlint:disable:next large_tuple
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }

    func toColor() -> Color {
        let rgb = self.rgba
        return Color(red: Double(rgb.red),
                     green: Double(rgb.green),
                     blue: Double(rgb.blue),
                     opacity: Double(rgb.alpha))
    }
}
