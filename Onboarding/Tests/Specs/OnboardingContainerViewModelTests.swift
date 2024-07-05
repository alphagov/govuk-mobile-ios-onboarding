import XCTest
import Combine

@testable import Onboarding

final class OnboardingContainerViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    func test_init_hasCorrectInitialState() throws {
        let sut = OnboardingContainerViewModel(
            onboardingService: MockOnboardingService(),
            onboardingType: .json("test"),
            dismissAction: {}
        )

        XCTAssertEqual(sut.state, .loading)
        XCTAssertEqual(sut.tabIndex, 0)
        //        XCTAssertEqual(sut.skipButtonTitle, "Skip")
        //        XCTAssertEqual(sut.skipButtonAcessibilityHint, "Skip")
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
            onboardingType: .json(expectedResource),
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

        mockOnboardingService._receivedDownloadDataCompletionHander?(.success(expectedSlides))

        wait(for: [expectation], timeout: 1)
    }

    func test_init_jsonType_fetchesSlides() throws {
        let mockOnboardingService = MockOnboardingService()

        let expectedResource = "MockOnboardingResponse"
        _ = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            onboardingType: .json(expectedResource),
            dismissAction: {}
        )
        switch mockOnboardingService._receivedDownloadDataOnboardingType {
        case .json(let resource):
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
            onboardingType: .model(expectedSlides),
            dismissAction: {}
        )
        switch mockOnboardingService._receivedDownloadDataOnboardingType {
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
            onboardingType: .model([]),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedDownloadDataCompletionHander?(.success(expectedSlides))

        XCTAssertEqual(sut.primaryButtonTitle, "primaryButtonTitle") //Continue
    }

    func test_getPrimaryButtonTitle_finalSlide_returnsExpectedTitle() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            onboardingType: .model([]),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedDownloadDataCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        XCTAssertEqual(sut.primaryButtonTitle, "lastButtonTitle") //Done
    }

    func test_isLastSlide_returnsTrueWhenOnTheLastSlide() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            onboardingType: .model([]),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedDownloadDataCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        XCTAssertTrue(sut.isLastSlide)
    }

    func test_isLastSlide_notLastSlide_returnsFalse() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            onboardingType: .model([]),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedDownloadDataCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 0

        XCTAssertFalse(sut.isLastSlide)
    }

    func test_action_notLastSlide_incrementsTabIndex() throws {
        let mockOnboardingService = MockOnboardingService()
        let sut = OnboardingContainerViewModel(
            onboardingService: mockOnboardingService,
            onboardingType: .model([]),
            dismissAction: {}
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedDownloadDataCompletionHander?(.success(expectedSlides))
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
            onboardingType: .model([]),
            dismissAction: {
                expectation.fulfill()
            }
        )
        let expectedSlides = [
            OnboardingSlide(image: "test", title: "test_title", body: "test_body"),
            OnboardingSlide(image: "test1", title: "test_title", body: "test_body")
        ]
        mockOnboardingService._receivedDownloadDataCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        sut.action()
        wait(for: [expectation], timeout: 1)
    }

}
