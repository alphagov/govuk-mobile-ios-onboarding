import XCTest

@testable import Onboarding

final class OnboardingServiceTests: XCTestCase {
    
    var sut: OnboardingService!

    override func setUpWithError() throws {
        sut = OnboardingService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchSlides_jsonSource_validFileName_returnsCorrectSlides() throws {
        sut.fetchSlides(source: .json("MockOnboardingResponse", .module)) { result in
            let slides = try? result.get()
            XCTAssertEqual(slides?.count, 3)
        }
    }
    
    func test_fetchSlides_jsonSource_inValidFileName_returnsError() throws {
        sut.fetchSlides(source: .json("Mock", .module)) { result in
            switch result {
            case .failure(OnboardingServiceError.loadJsonError):
                XCTAssertTrue(true)
            default:
                XCTFail("expect to load json error")
            }
        }
    }
    
    func test_fetchSlides_modelSource_returnsCorrectSlides() throws {
        let slides:[OnboardingSlide] = [
            OnboardingSlide(image: "onboarding_placeholder_screen_1",
                            title: "Get things done on the go",
                            body: "Access government services and information on your phone using the GOV.UK app", alias: ""),
            OnboardingSlide(image: "onboarding_placeholder_screen_2",
                            title: "Quickly get back to previous pages",
                            body: "Pages you've visited are saved so you can easily return to them",
                            alias:""),
            OnboardingSlide(image: "onboarding_placeholder_screen_3",
                            title: "Tailored to you",
                            body: "Choose topics that are relevant to you so you can find what you need faster",
                            alias: "")
        ]
        sut.fetchSlides(source: .model(slides)) { result in
            let slides = try? result.get()
            XCTAssertEqual(slides?.count, 3)
        }
    }
    
    func test_fetchSlides_modelSource_whenGivenEmptyArray_returnsEmptyArrayOfSlides() throws {
        let slides:[OnboardingSlide] = []
        sut.fetchSlides(source: .model(slides)) { result in
            let slides = try? result.get()
            XCTAssertEqual(slides?.count, 0)
        }
    }
    
    func test_fetchSlides_jsonSource_inValidFileJson_returnsError() throws {
        sut.fetchSlides(source: .json("MockOnboardingResponseInvalid", .module)) { result in
            switch result {
            case .failure(DecodingError.dataCorrupted):
                XCTAssertTrue(true)
            default:
                XCTFail("expect to load json error")
            }
        }
    }
}
