import Foundation
import SwiftUI

public class OnboardingSlideImageViewModel: OnboardingSlideViewModelInterface {
    public let title: String
    public let body: String
    public let name: String
    public let contentView: AnyView
    public let primaryButtonTitle: String
    public let secondaryButtonTitle: String

    public init(slide: OnboardingSlide,
                bundle: Bundle = .main,
                primaryButtonTitle: String,
                secondaryButtonTitle: String) {
        self.title = slide.title
        self.body = slide.body
        self.name = slide.name
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.contentView = AnyView(
            Image(decorative: slide.image, bundle: bundle)
        )
    }

    public func didAppear() { /* Do nothing */ }
}
