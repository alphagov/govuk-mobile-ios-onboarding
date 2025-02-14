import Foundation
import SwiftUICore

open class OnboardingSlideViewModel: ObservableObject {

    public let slide: OnboardingSlide

    public init(slide: OnboardingSlide) {
        self.slide = slide
    }

    open var title: String {
        slide.title
    }

    open var body: String {
        slide.body
    }

    open var image: AnyView {
        fatalError("This needs overriding")
    }

    open func startAnimation() { }

    open func trackSlideView() { }
}
