import Foundation
import SwiftUI

public class OnboardingSlideImageViewModel: OnboardingSlideViewModelInterface {
    public let title: String
    public let body: String
    public let name: String
    public let contentView: AnyView
    public let primaryButtonTitle: String
    public let primaryButtonAccessibilityHint: String?
    public let secondaryButtonTitle: String
    public let secondaryButtonAccessibilityHint: String?

    public init(slide: OnboardingSlide,
                bundle: Bundle = .main,
                primaryButtonTitle: String,
                primaryButtonAccessibilityHint: String?,
                secondaryButtonTitle: String,
                secondaryButtonAccessibilityHint: String?) {
        self.title = slide.title
        self.body = slide.body
        self.name = slide.name
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAccessibilityHint = primaryButtonAccessibilityHint
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonAccessibilityHint = secondaryButtonAccessibilityHint
        self.contentView = AnyView(
            Image(decorative: slide.image, bundle: bundle)
        )
    }

    public func didAppear() { /* Do nothing */ }
}
