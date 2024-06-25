import SwiftUI

struct OnboardingSlideView: View {
    private var model: OnboardingSlideModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(model: OnboardingSlideModel) {
        self.model = model
    }
    var body: some View {
        ScrollView {
            VStack {
                if verticalSizeClass != .compact {
                    Image(decorative: model.image, bundle: Bundle.module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 225, height: 225)
                        .padding([.bottom])
                }
                Text(model.title).font(.title).fontWeight(.bold).multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityLabel(Text(model.title))
                    .accessibility(sortPriority: 3)
                    .padding(.top, verticalSizeClass == .compact ? 32 : 0)
                Text(model.description).multilineTextAlignment(.center)
                    .accessibilityLabel(Text(model.description))
                    .accessibility(sortPriority: 2)
                    .padding([.top])
                Spacer()
            }.accessibilityElement(children: .contain)
        }
    }
}


#Preview {
    OnboardingSlideView(model: OnboardingSlideModel(id: "", image: "", title: "", description: ""))
}
