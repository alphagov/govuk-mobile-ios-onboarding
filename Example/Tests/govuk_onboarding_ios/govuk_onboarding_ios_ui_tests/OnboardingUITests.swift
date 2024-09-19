import XCTest

final class OnboardingUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    override func tearDownWithError() throws {
        XCUIDevice.shared.orientation = .portrait
    }
    
    func test_actionButton_notOnLastSlide_isSetToContinue() {
        //Given
        let actionButton = app.buttons["Continue"]
        //Then
        XCTAssertTrue(actionButton.exists)
    }
    
    func test_actionButton_onLastSlide_isNotSetToContinue(){
        //Given
        let actionButton = app.buttons["Continue"]
        //When
        actionButton.tap()
        actionButton.tap()
        //Then
        XCTAssertFalse(actionButton.exists)
    }
    
    func test_titleLabel_exists() {
        //Given
        let scrollViewsQuery = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let elementsQuery = scrollViewsQuery.otherElements
        let titleLabel = elementsQuery.staticTexts["Get things done on the go"]
        //Then
        XCTAssertTrue(titleLabel.exists)
    }
    
    func test_descriptionLabel_exists() {
        //Given
        let descriptionLabel = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
            .staticTexts["Access government services and information on your phone using the GOV.UK app"]
        //Then
        XCTAssertTrue(descriptionLabel.exists)
    }
    
    func test_actionButton_onLastSlide_isSetToDone() {
        let doneActionButton = app.buttons["Done"]
        let continueActionButton = app.buttons["Continue"]

        continueActionButton.tap()

        let tabView = app.collectionViews["container.tabview"]
        tabView.swipeLeft()

        XCTAssertTrue(doneActionButton.exists)
        XCTAssertTrue(doneActionButton.isHittable)
    }
    
    func test_skipButton_whenNotOnLastSlide_exists() {
        //Given
        let skipButton = app.buttons["Skip"]
        //Then
        XCTAssertTrue(skipButton.exists)
        XCTAssertTrue(skipButton.isHittable)
    }
    
    func test_skipButton_onLastSlide_isNotHittable() {
        //Given
        let skipButton = app.buttons["Skip"]
        let actionButton = app.buttons["Continue"]
        //When
        actionButton.tap()
        actionButton.tap()
        //Then
        XCTAssertTrue(skipButton.exists)
        XCTAssertFalse(skipButton.isHittable)
    }
    
    func test_image_whenInPortraiteMode_exists() {
        //Given
        let image = app.descendants(matching: .image)
        //Then
        XCTAssertTrue(image.element.exists)
    }
    
    func test_skipButton_inLandscapeMode_onTheLastSlide_doesNotExists() {
        //Given
        let actionButton = app.buttons["Continue"]
        let skipButton = app.buttons["Skip"]
        //When
        actionButton.tap()
        actionButton.tap()
        XCUIDevice.shared.orientation  = .landscapeRight
        //Then
        XCTAssertFalse(skipButton.isHittable)
        XCTAssertFalse(skipButton.exists)
    }
    
    func test_skipButton_whenTapped_endsOnboarding() {
        //Given
        let skipButton = app.buttons["Skip"]
        let loadButton =  app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //When
        skipButton.tap()
        //Then
        XCTAssertTrue(loadButton.exists)
        XCTAssertTrue(loadButton.isHittable)
        XCTAssertFalse(skipButton.exists)
    }
    
    func test_doneButton_whenTapped_endsOnboarding() {
        //Given
        let doneButton = app.buttons["Done"]
        let loadButton =  app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let continueButton = app.buttons["Continue"]
        //When
        continueButton.tap()
        continueButton.tap()
        doneButton.tap()
        //Then
        XCTAssertTrue(loadButton.exists)
        XCTAssertTrue(loadButton.isHittable)
        XCTAssertFalse(doneButton.exists)
    }
}
