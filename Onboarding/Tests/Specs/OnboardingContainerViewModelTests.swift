import XCTest
@testable import Onboarding

final class OnboardingContainerViewModelTests: XCTestCase {
    var sut:OnboardingContainerViewModel?
    override func setUpWithError() throws {
        
        sut = OnboardingContainerViewModel(onboardingService: MockOnboardingService(),
                                           dismissAction: {},
                                           onboardingType: .json("MockOnboardingResponse"))
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_getActionButtonTitle_returnsCorrectString() throws {
        let actionButtonTitle = sut?.getActionButtonTitle()
        XCTAssertEqual(actionButtonTitle, "primaryButtonTitle")
    }
    
    func test_getActionButtonTitle_returnsCorrectStringWhenOnLastSlide() throws {
        for var i in 0...1 {
            sut?.action()
            i += 1
        }
        let actionButtonTitle = sut?.getActionButtonTitle()
        XCTAssertEqual(actionButtonTitle, "lastButtonTitle")
    }
    
    
    func test_isLastSlide_returnsTrueWhenOnTheLastSlide() throws {
        guard let sut = sut else { return }
        for var i in 0...1 {
            sut.action()
            i += 1
        }
        XCTAssertTrue(sut.isLastSlide)
    }
    
    func test_isLastSlide_returnsFalseWhenNotOnTheLastSlide() throws {
        guard let sut = sut else { return }
        sut.action()
        XCTAssertFalse(sut.isLastSlide)
    }
    
    func test_action_incrementsTabIndexWhenNotTheLastSlide() throws {
        guard let sut = sut else { return }
        XCTAssertEqual(sut.tabIndex, 0)
        sut.action()
        XCTAssertEqual(sut.tabIndex, 1)
    }
    
    func test_state_isSetToLoadedWhenSlidesSuccesfullyRetreived() throws {
        guard let sut = sut else { return }
        let slides:[OnboardingSlide] = 
        [OnboardingSlide(
            image: "onboarding_placeholder_screen_1",
            title: "Get things done on the go",
            body: "Access government services and information on your phone using the GOV.UK app"),
         OnboardingSlide(image: "onboarding_placeholder_screen_2",
            title: "Quickly get back to previous pages",
            body: "Pages you’ve visited are saved so you can easily return to them"),
         OnboardingSlide(image: "onboarding_placeholder_screen_3",
            title: "Tailored to you",
            body: "Choose topics that are relevant to you so you can find what you need faster")]
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(sut.state, .loaded(slides))
        }
    }
}
