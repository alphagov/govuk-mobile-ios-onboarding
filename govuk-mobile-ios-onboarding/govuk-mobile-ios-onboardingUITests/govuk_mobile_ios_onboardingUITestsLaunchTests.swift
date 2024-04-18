//
//  govuk_mobile_ios_onboardingUITestsLaunchTests.swift
//  govuk-mobile-ios-onboardingUITests
//
//  Created by Thomas Bates on 18/04/2024.
//

import XCTest

final class govuk_mobile_ios_onboardingUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
