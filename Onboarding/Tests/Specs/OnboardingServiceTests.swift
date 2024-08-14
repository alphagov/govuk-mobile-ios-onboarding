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
        let numberOfSlides = Int.random(in: 1...100)
        let slides:[OnboardingSlide] = OnboardingSlide.arrange(count: numberOfSlides)

        sut.fetchSlides(source: .model(slides)) { result in
            let slides = try? result.get()
            XCTAssertEqual(slides?.count, numberOfSlides)
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

