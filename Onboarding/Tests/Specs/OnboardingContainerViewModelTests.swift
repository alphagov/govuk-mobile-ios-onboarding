import XCTest
import Combine
import Foundation

@testable import Onboarding

final class OnboardingContainerViewModelTests: XCTestCase {

    private var sut: OnboardingContainerViewModel?
    private var cancellables = Set<AnyCancellable>()

    func test_init_hasCorrectInitialState() throws {
        let sut = OnboardingContainerViewModel(
            slideProvider: MockOnboardingSlideProvider(),
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )

        switch sut.state {
        case .loading:
            XCTAssert(true)
        default:
            XCTFail("Expected loading")
        }
        XCTAssertEqual(sut.tabIndex, 0)
    }

    func test_init_fetchedSlides_changesState() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()

        let expectedSlides = OnboardingSlide.arrange(count: 2).map {
            OnboardingSlideImageViewModel(
                slide: $0,
                primaryButtonTitle: "primary test",
                secondaryButtonTitle: "secondary test"
            )
        }

        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        switch sut.state {
        case .loaded(let viewModels):
            XCTAssert(viewModels.count == expectedSlides.count)
            XCTAssert(viewModels.first?.title == expectedSlides.first?.title)
        default:
            XCTFail("Expected loaded")
        }
    }

    func test_init_fetchedSlides_emptySlides_callsDismiss() throws {
        let mockSlideProvider = MockOnboardingSlideProvider()

        let expectation = XCTestExpectation(description: "Empty slides")
        sut = OnboardingContainerViewModel(
            slideProvider: mockSlideProvider,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {
                expectation.fulfill()
            }
        )

        mockSlideProvider._receivedFetchSlidesCompletionHander?(.success([]))

        wait(for: [expectation], timeout: 1)
    }

    func test_primaryButtonViewModel_returnsExpectedValue() throws {
        let mockSlideProvider = MockOnboardingSlideProvider()
        let sut = OnboardingContainerViewModel(
            slideProvider: mockSlideProvider,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = OnboardingSlide.arrange(count: 2).enumerated().map {
            OnboardingSlideImageViewModel(
                slide: $0.element,
                primaryButtonTitle: "Primary \($0.offset)",
                secondaryButtonTitle: "Secondary \($0.offset)"
            )
        }
        mockSlideProvider._receivedFetchSlidesCompletionHander?(.success(expectedSlides))

        sut.tabIndex = 0
        XCTAssertEqual(sut.primaryButtonViewModel.localisedTitle, "Primary 0")

        sut.tabIndex = 1
        XCTAssertEqual(sut.primaryButtonViewModel.localisedTitle, "Primary 1")
    }

    func test_isLastSlide_returnsTrueWhenOnTheLastSlide() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        XCTAssertTrue(sut.isLastSlide)
    }

    func test_isLastSlide_notLastSlide_returnsFalse() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        XCTAssertFalse(sut.isLastSlide)
    }

    func test_primaryAction_notLastSlide_incrementsTabIndex() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 0

        XCTAssertEqual(sut.tabIndex, 0)
        sut.primaryButtonViewModel.action()

        XCTAssertEqual(sut.tabIndex, 1)
    }

    func test_primaryAction_lastSlide_completesFlow() throws {
        let expectation = XCTestExpectation(description: "Final slide expectation")
        let mockOnboardingService = MockOnboardingSlideProvider()
        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {
                expectation.fulfill()
            },
            dismissAction: { }
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.tabIndex = 1

        sut.primaryButtonViewModel.action()
        wait(for: [expectation], timeout: 1)
    }

    func test_skip_completesFlow() async throws {
        let mockOnboardingService = MockOnboardingSlideProvider()

        let expectation = XCTestExpectation(description: "Empty slides")
        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {
                expectation.fulfill()
            }
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))

        let secondaryAction = sut.secondaryButtonViewModel.action
        secondaryAction()

        await fulfillment(of: [expectation], timeout: 1)
    }

    func test_primaryButtonAccessibilityHint_lastSlide_returnsExpectedResult() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()

        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))

        sut.tabIndex = 1
        XCTAssertEqual(sut.primaryButtonAccessibilityHint, "Finish onboarding")
        XCTAssertEqual(sut.secondaryButtonAccessibilityHint, "Skip onboarding")
    }

    func test_accessibilityHints_notLastSlide_returnsExpectedResult() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()

        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))

        sut.tabIndex = 0
        XCTAssertEqual(sut.primaryButtonAccessibilityHint, "Go to the next slide")
        XCTAssertEqual(sut.secondaryButtonAccessibilityHint, "Skip onboarding")
    }

    func test_trackNavigationEvent_tracksNavigationEvent() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let analyticsService = MockAnalyticsService()

        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: analyticsService,
            completeAction: {},
            dismissAction: {}
        )

        let expectedSlides: [MockSlideViewModel] = [
            MockSlideViewModel(
                title: "test_title_1",
                name: "navigation_1"
            ),
            MockSlideViewModel(
                title: "test_title_2",
                name: "navigation_2"
            ),
            MockSlideViewModel(
                title: "test_title_3",
                name: "navigation_3"
            )
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.didShow(index: 1)

        XCTAssertEqual(analyticsService._trackOnboardingScreenReceivedScreens.count, 1)
        let screen = analyticsService._trackOnboardingScreenReceivedScreens.first
        XCTAssertEqual(screen?.trackingName, "navigation_2")
        XCTAssertEqual(screen?.trackingTitle, "test_title_2")
        XCTAssertEqual(screen?.trackingClass, "OnboardingSlideView")
    }

    func test_primaryAction_onLastSlide_tracksDoneEvent() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let analyticsService = MockAnalyticsService()

        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: analyticsService,
            completeAction: {},
            dismissAction: {}
        )

        let expectedSlides = [
            MockSlideViewModel(primaryButtonTitle: "primary_1"),
            MockSlideViewModel(primaryButtonTitle: "primary_2")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.primaryButtonViewModel.action()
        sut.primaryButtonViewModel.action()

        XCTAssertEqual(analyticsService._trackOnboardingEventReceivedEvents.count, 2)

        let lastEvent = analyticsService._trackOnboardingEventReceivedEvents.last
        XCTAssertEqual(lastEvent?.name, "Navigation")
        XCTAssertEqual(lastEvent?.text, "primary_2")
        XCTAssertEqual(lastEvent?.type, "Button")
    }

    func test_primaryAction_notOnLastScreen_tracksContinueEvent() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let analyticsService = MockAnalyticsService()

        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: analyticsService,
            completeAction: {},
            dismissAction: {}
        )

        let expectedSlides = [
            MockSlideViewModel(primaryButtonTitle: "primary_1"),
            MockSlideViewModel(primaryButtonTitle: "primary_2")
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.primaryButtonViewModel.action()

        XCTAssertEqual(analyticsService._trackOnboardingEventReceivedEvents.count, 1)
        XCTAssertEqual(analyticsService._trackOnboardingEventReceivedEvents.first?.name, "Navigation")
        XCTAssertEqual(analyticsService._trackOnboardingEventReceivedEvents.last?.text, "primary_1")
        XCTAssertEqual(analyticsService._trackOnboardingEventReceivedEvents.last?.type, "Button")
    }

    func test_primaryAction_notOnLastScreen_postsScreenChangedNotification() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let accessibilityPoster = MockAccessibilityPoster.self
        accessibilityPoster._receivedPostNotification = nil
        accessibilityPoster._receivedPostArgument = nil
        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            accessibilityPoster: accessibilityPoster,
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = [
            MockSlideViewModel(),
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.primaryButtonViewModel.action()

        XCTAssertEqual(accessibilityPoster._receivedPostNotification, .screenChanged)
        XCTAssertNil(accessibilityPoster._receivedPostArgument)
    }

    func test_primaryAction_onLastScreen_doesntPostScreenChangedNotification() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let accessibilityPoster = MockAccessibilityPoster.self
        accessibilityPoster._receivedPostNotification = nil
        accessibilityPoster._receivedPostArgument = nil
        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            accessibilityPoster: accessibilityPoster,
            completeAction: {},
            dismissAction: {}
        )
        let expectedSlides = [
            MockSlideViewModel()
        ]
        mockOnboardingService._receivedFetchSlidesCompletionHander?(.success(expectedSlides))
        sut.primaryButtonViewModel.action()

        XCTAssertNil(accessibilityPoster._receivedPostNotification)
        XCTAssertNil(accessibilityPoster._receivedPostArgument)
    }

    func test_trackPageControllerPressEvent_tracksEvent() throws {
        let mockOnboardingService = MockOnboardingSlideProvider()
        let analyticsService = MockAnalyticsService()

        let sut = OnboardingContainerViewModel(
            slideProvider: mockOnboardingService,
            analyticsService: analyticsService,
            completeAction: {},
            dismissAction: {}
        )

        sut.trackPageControllerPressEvent()

        XCTAssertEqual(analyticsService._trackOnboardingEventReceivedEvents.count, 1)
        let event = analyticsService._trackOnboardingEventReceivedEvents.first
        XCTAssertEqual(event?.name, "Navigation")
        XCTAssertNil(event?.text)
        XCTAssertEqual(event?.type, "Dot")
    }
}
