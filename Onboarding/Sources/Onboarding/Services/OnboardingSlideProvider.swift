import Foundation

public typealias OnboardingSlideProviderResult = Result<[any OnboardingSlideViewModelInterface], any Error>
public typealias OnboardingSlideProviderCompletion = (OnboardingSlideProviderResult) -> Void

public protocol OnboardingSlideProvider {
    func fetchSlides(completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void)
}
