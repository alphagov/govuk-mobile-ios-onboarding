import Foundation

public protocol OnboardingSlideProvider {
    func fetchSlides(completion: @escaping (Result<[OnboardingSlideViewModel], Error>) -> Void)
}
