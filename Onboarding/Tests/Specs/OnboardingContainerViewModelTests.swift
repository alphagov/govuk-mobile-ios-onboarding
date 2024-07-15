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
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]

        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json(expectedResource),
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
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        _ = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model(expectedSlides),
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
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))

        XCTAssertEqual(sut.primaryButtonTitle, "Continue")
    }

    func test_getPrimaryButtonTitle_finalSlide_returnsExpectedTitle() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
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
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
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
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 0

        XCTAssertFalse(sut.isLastSlide)
    }

    func test_action_notLastSlide_incrementsTabIndex() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 0

        XCTAssertEqual(sut.tabIndex, 0)
        sut.action()

        XCTAssertEqual(sut.tabIndex, 1)
    }

    func test_action_lastSlide_completesFlow() throws {
        let expectation = XCTestExpectation(description: "Final slide expectation")
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .model([]),
            dismissAction: {
                expectation.fulfill()
            }
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        sut.action()
        wait(for: [expectation], timeout: 1)
    }

    func test_skip_completesFlow() throws {
        let mockOnboardingService = MockOnboardingService()

        let expectedResource = "MockOnboardingResponse"

        let expectation = XCTestExpectation(description: "Empty slides")
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json(expectedResource),
            dismissAction: {
                expectation.fulfill()
            }
        )
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))

        sut.skip()

        wait(for: [expectation], timeout: 1)
    }

    func test_actionButtonAccessibilityHint_lastSlide_returnsExpectedResult() throws {
        let mockOnboardingService = MockOnboardingService()

        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            source: .json("test"),
            dismissAction: {}
        )
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test2", title: "test_title", body: "test_body")
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
            dismissAction: {}
        )
        let slides = [
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test2", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(slides))

        sut.tabIndex = 0
        XCTAssertEqual(sut.actionButtonAccessibilityHint, "Go to the next slide")
    }
}
