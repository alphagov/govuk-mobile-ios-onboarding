import XCTest

@testable import Onboarding

class OnboardingSlideTests: XCTestCase {

    func test_init_setsExpectedValues() {
        let subject = OnboardingSlide(
            image: "test_image",
            title: "test_title",
            body: "test_body",
            name: ""
        )

        XCTAssertEqual(subject.image, "test_image")
        XCTAssertEqual(subject.title, "test_title")
        XCTAssertEqual(subject.body, "test_body")
    }

}
