import Foundation

public protocol OnboardingSlideProvider {
    func fetchSlides(completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void)
}
