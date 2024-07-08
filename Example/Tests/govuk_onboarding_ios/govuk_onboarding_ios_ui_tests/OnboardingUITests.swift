import XCTest

final class OnboardingUITests: XCTestCase {
    
    func test_actionButton_isSetToContinue_ifNotOnLastSlide() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let actionButton = app.buttons["Continue"]
        XCTAssertTrue(actionButton.exists)
    }
    
    func test_actionButton_isNotSetToContinueOnLastSlide(){
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let actionButton = app.buttons["Continue"]
        let view = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element/*[[".cells.scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        view.swipeLeft()
        view.swipeLeft()
        XCTAssertFalse(actionButton.exists)
    }
    
    func test_titleLabel_exists() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let scrollViewsQuery = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let elementsQuery = scrollViewsQuery.otherElements
        let titleLabel = elementsQuery.staticTexts["Get things done on the go"]
        XCTAssertTrue(titleLabel.exists)
    }
    
    func test_descriptionlabel_exists() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Load"].tap()
        let descriptionLabel = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.staticTexts["Access government services and information on your phone using the GOV.UK app"]
        XCTAssertTrue(descriptionLabel.exists)
    }
    
    func test_actionButton_isSetToDone_onLastSlide() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let view = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element/*[[".cells.scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        view.swipeLeft()
        view.swipeLeft()
        let actionButton = app.buttons["Done"]
        XCTAssertTrue(actionButton.exists)
    }
    
    func test_skipButton_isHittable_whenNotOnLastSlide() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let skipButton = app.buttons["Skip"]
        XCTAssertTrue(skipButton.exists)
        XCTAssertTrue(skipButton.isHittable)
    }
    
    func test_skipButton_isNotHittable_OnLastSlide() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let skipButton = app.buttons["Skip"]
        let view = app.collectionViews/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element/*[[".cells.scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        view.swipeLeft()
        view.swipeLeft()
        XCTAssertFalse(skipButton.isHittable)
    }
    
    func test_skipButton_doesNotExists_inLandscapeModeOnTheLastSlide() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIDevice.shared.orientation = .landscapeRight
        XCUIDevice.shared.orientation = .landscapeRight
        let actionButton = app.buttons["Continue"]
        let skipButton = app.buttons["Skip"]
        actionButton.tap()
        actionButton.tap()
        XCTAssertFalse(skipButton.exists)
    }
    func test_image_exists_whenInPortraitaMode(){
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let image = app.descendants(matching: .image)
        XCTAssertTrue(image.element.exists)
    }
    
    func test_image_doesNotExists_whenInLandscapeMode(){
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Load"]/*[[".buttons[\"Load\"].staticTexts[\"Load\"]",".staticTexts[\"Load\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIDevice.shared.orientation = .landscapeRight
        let image = app.descendants(matching: .image)
        XCTAssertFalse(image.element.exists)
    }
}
