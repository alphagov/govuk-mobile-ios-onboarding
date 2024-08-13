import XCTest
import Combine

@testable import Onboarding

final class OnboardingContainerViewModelTests: XCTestCase {

    private var sut: OnboardingContainerViewModel?
    private var cancellables = Set<AnyCancellable>()
    

    func test_init_hasCorrectInitialState() throws {
        let sut = OnboardingContainerViewModel(
            onboardingService: MockOnboardingService(),
            source: .json("test"), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )

        XCTAssertEqual(sut.state, .loading)
        XCTAssertEqual(sut.tabIndex, 0)
        XCTAssertEqual(sut.skipButtonTitle, "Skip")
        XCTAssertEqual(sut.skipButtonAcessibilityHint, "Skip onboarding")
    }

    func test_init_fetchedSlides_changesState() throws {
        let mockOnboardingService = MockOnboardingService()

        let expectedResource = "MockOnboardingResponse"
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]

        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json(expectedResource), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let expectation = XCTestExpectation(description: "Slide return")
        sut.$state
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, .loaded(expectedSlides))
                expectation.fulfill()
            })
            .store(in: &cancellables)

        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))

        wait(for: [expectation], timeout: 1)
    }

    func test_init_fetchedSlides_emptySlides_completesFlow() throws {
        let mockOnboardingService = MockOnboardingService()

        let expectedResource = "MockOnboardingResponse"

        let expectation = XCTestExpectation(description: "Empty slides")
        sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json(expectedResource),
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                expectation.fulfill()
            }
        )

        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success([]))

        wait(for: [expectation], timeout: 1)
    }

    func test_init_json_fetchesSlides() throws {
        let mockOnboardingService = MockOnboardingService()
        let expectedResource = "MockOnboardingResponse"
        _ = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json(expectedResource), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        switch mockOnboardingService._receivedFetchSlidesSource {
        case .json(let resource, _):
            XCTAssertEqual(resource, expectedResource)
        default:
            XCTFail("Expected a json type")
        }
    }

    func test_init_modelType_fetchesSlides() throws {
        let mockOnboardingService = MockOnboardingService()
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        _ = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model(expectedSlides),
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        switch mockOnboardingService._receivedFetchSlidesSource {
        case .model(let slides):
            XCTAssertEqual(slides, expectedSlides)
        default:
            XCTFail("Expected a model type")
        }
    }

    func test_primaryButtonTitle_notOnFinalSlide_returnsExpectedTitle() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))

        XCTAssertEqual(sut.primaryButtonTitle, "Continue")
    }

    func test_getPrimaryButtonTitle_finalSlide_returnsExpectedTitle() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        XCTAssertEqual(sut.primaryButtonTitle, "Done")
    }

    func test_isLastSlide_returnsTrueWhenOnTheLastSlide() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        XCTAssertTrue(sut.isLastSlide)
    }

    func test_isLastSlide_notLastSlide_returnsFalse() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 0

        XCTAssertFalse(sut.isLastSlide)
    }

    func test_primaryAction_notLastSlide_incrementsTabIndex() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 0

        XCTAssertEqual(sut.tabIndex, 0)
        sut.primaryAction()

        XCTAssertEqual(sut.tabIndex, 1)
    }

    func test_primaryAction_lastSlide_completesFlow() throws {
        let expectation = XCTestExpectation(description: "Final slide expectation")
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                expectation.fulfill()
            }
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        sut.primaryAction()
        wait(for: [expectation], timeout: 1)
    }

    func test_skip_completesFlow() async throws {
        let mockOnboardingService = MockOnboardingService()

        let expectedResource = "MockOnboardingResponse"

        let expectation = XCTestExpectation(description: "Empty slides")
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json(expectedResource), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                expectation.fulfill()
            }
        )
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))

        let secondaryAction = sut.secondaryButtonViewModel.action
        try await secondaryAction()

       await fulfillment(of: [expectation], timeout: 1)
    }

    func test_actionButtonAccessibilityHint_lastSlide_returnsExpectedResult() throws {
        let mockOnboardingService = MockOnboardingService()

        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json("test"), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test2", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))

        sut.tabIndex = 1
        XCTAssertEqual(sut.actionButtonAccessibilityHint, "Finish onboarding")
    }

    func test_actionButtonAccessibilityHint_notLastSlide_returnsExpectedResult() throws {
        let mockOnboardingService = MockOnboardingService()

        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json("test"), 
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test2", title: "test_title", body: "test_body", alias: "")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))

        sut.tabIndex = 0
        XCTAssertEqual(sut.actionButtonAccessibilityHint, "Go to the next slide")
    }
    
    func test_trackNavigationEvent_tracksNavigationEvent() throws {
        //Given
        let mockOnboardingService = MockOnboardingService()
        let analyticsService = MockAnalyticsService()
        
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json("test"), 
            analyticsService: analyticsService,
            dismissAction: {})
        
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test2", title: "test_title", body: "test_body", alias: "")
        ]
        //When
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))
        sut.trackNavigationEvent()
        //Then
        XCTAssertEqual(analyticsService._events.count,1)
        XCTAssertEqual(analyticsService._events[0].log.0, "navigation")
    }
    
    func  test_primaryAction_onLastSlide_tracksDoneEvent() throws {
        //Given
        let mockOnboardingService = MockOnboardingService()
        let analyticsService = MockAnalyticsService()
        
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json("test"), 
            analyticsService: analyticsService,
            dismissAction: {})
        
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test2", title: "test_title", body: "test_body", alias: "")
        ]
        //When
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))
        sut.primaryAction()
        sut.primaryAction()
        //Then
        XCTAssertEqual(analyticsService._events.count,2)
        XCTAssertEqual(analyticsService._events[1].log.0, "done")
    }
    
    func  test_primaryAction_notOnLastScreen_tracksContinueEvent() throws {
        //Given
        let mockOnboardingService = MockOnboardingService()
        let analyticsService = MockAnalyticsService()
        
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json("test"), 
            analyticsService: analyticsService,
            dismissAction: {})
        
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test2", title: "test_title", body: "test_body", alias: ""),
            OnboardingSlide(image: "test3", title: "test_title", body: "test_body", alias: "")]
        //When
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))
        sut.primaryAction()
        //Then
        XCTAssertEqual(analyticsService._events.count,1)
        XCTAssertEqual(analyticsService._events[0].log.0, "continue")
    }
}
