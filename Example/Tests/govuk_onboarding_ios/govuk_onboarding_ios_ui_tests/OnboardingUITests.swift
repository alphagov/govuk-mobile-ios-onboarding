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
    
    func test_actionButton_isSetToContinue_ifNotOnLastSlide() {
        //Given
        let actionButton = app.buttons["Continue"]
        //Then
        XCTAssertTrue(actionButton.exists)
    }
    
    func test_actionButton_isNotSetToContinueOnLastSlide(){
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
    
    func test_descriptionlabel_exists() {
        //Given
        let descriptionLabel = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
            .staticTexts["Access government services and information on your phone using the GOV.UK app"]
        //Then
        XCTAssertTrue(descriptionLabel.exists)
    }
    
    func test_actionButton_isSetToDone_onLastSlide() {
        //Given
        let doneActionButton = app.buttons["Done"]
        let continueActionButton = app.buttons["Continue"]
        let view = app.collectionViews
            .scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element
        //When
        continueActionButton.tap()
        continueActionButton.tap()
        view.swipeLeft()
        //Then
        XCTAssertTrue(doneActionButton.exists)
        XCTAssertTrue(doneActionButton.isHittable)
    }
    
    func test_skipButton_exists_whenNotOnLastSlide() {
        //Given
        let skipButton = app.buttons["Skip"]
        //Then
        XCTAssertTrue(skipButton.exists)
        XCTAssertTrue(skipButton.isHittable)
    }
    
    func test_skipButton_isNotHittable_OnLastSlide() {
        //Given
        let skipButton = app.buttons["Skip"]
        let actionButton = app.buttons["Continue"]
        //When
        actionButton.tap()
        actionButton.tap()
        //Then
        XCTAssertFalse(skipButton.isHittable)
    }
    
    func test_image_exists_whenInPortraitaMode() {
        //Given
        let image = app.descendants(matching: .image)
        //Then
        XCTAssertTrue(image.element.exists)
    }
    
    func test_skipButton_doesNotExists_inLandscapeModeOnTheLastSlide() {
        //Given
        let actionButton = app.buttons["Continue"]
        let skipButton = app.buttons["Skip"]
        //When
        XCUIDevice.shared.orientation = .landscapeRight
        actionButton.tap()
        actionButton.tap()
        //Then
        XCTAssertFalse(skipButton.exists)
    }
    
    func test_pageController_exists(){
        //Given
        let pageController = app.pageIndicators["page 1 of 3"].children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        //Then
        XCTAssertTrue(pageController.exists)
    }
    
    func test_skipButton_tapped_endsOnboarding() {
        //Given
        let skipButton = app.buttons["Skip"]
        let loadButton =  app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        //When
        skipButton.tap()
        //Then
        XCTAssertTrue(loadButton.exists)
        XCTAssertFalse(skipButton.exists)
    }
    
    func test_doneButton_tapped_endsOnboarding() {
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
        XCTAssertFalse(doneButton.exists)
    }
}
