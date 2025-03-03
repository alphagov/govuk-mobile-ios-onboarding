import Foundation
import Testing

@testable import Onboarding

@Suite
struct OnboardingSlideImageViewModelTests {

    @Test()
    func init_setsExpectedValues() {
        let expectedSlide = OnboardingSlide.arrange()
        let expectedPrimaryButtonTitle = UUID().uuidString
        let expectedSecondaryButtonTitle = UUID().uuidString
        let sut = OnboardingSlideImageViewModel(
            slide: expectedSlide,
            primaryButtonTitle: expectedPrimaryButtonTitle,
            primaryButtonAccessibilityHint: nil,
            secondaryButtonTitle: expectedSecondaryButtonTitle,
            secondaryButtonAccessibilityHint: nil
        )

        #expect(sut.title == expectedSlide.title)
        #expect(sut.body == expectedSlide.body)
        #expect(sut.name == expectedSlide.name)
        #expect(sut.primaryButtonTitle == expectedPrimaryButtonTitle)
        #expect(sut.secondaryButtonTitle == expectedSecondaryButtonTitle)
    }

}
