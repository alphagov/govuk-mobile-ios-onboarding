import XCTest

import GDSCommon

@testable import Onboarding

final class OnboardingCoordinatorTests: XCTestCase {
    var mainCoordinator: MockCoordinator!
    var navController: UINavigationController!
    var sut: OnboardingCoordinator!

    @MainActor
    override func setUp() {
        super.setUp()
        navController = .init()
        mainCoordinator = .init()
        sut = .init(
            parentCoordinator: mainCoordinator,
            root: navController,
            complete: {}
        )
    }

    override func tearDown() {
        navController = nil
        mainCoordinator = nil
        sut = nil

        super.tearDown()
    }

    @MainActor
    func test_start_pushesWelcomeScreen() throws {
        XCTAssertEqual(sut.root.viewControllers.count, 0)
        sut.start()
        XCTAssertEqual(sut.root.viewControllers.count, 1)

        _ = try XCTUnwrap(sut.root.topViewController as? PageControllerViewController)
    }
}
