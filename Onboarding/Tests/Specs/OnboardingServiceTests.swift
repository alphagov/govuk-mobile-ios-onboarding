//
@testable import Onboarding
import XCTest

final class OnboardingServiceTests: XCTestCase {
    
    var sut:OnboardingService!

    override func setUpWithError() throws {
        sut = OnboardingService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

//    func test_fetchSlides_jsonSource_validFileName_returnsCorrectSlides() throws {
//        sut.fetchSlides(source: .json("Onboarding")) { result in
//            let slides = try? result.get()
//            XCTAssertEqual(slides?.count, 3)
//        }
//    }
    
    func test_fetchSlides_jsonSource_inValidFileName_returnsCorrectSlides() throws {
      
    }
    
    //test_<method>_<context>_<context2>_<expectation>

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
