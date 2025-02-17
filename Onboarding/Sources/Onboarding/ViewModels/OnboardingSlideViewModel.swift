import Foundation
import SwiftUICore

import Combine

public protocol OnboardingSlideViewModelInterface: ObservableObject {
    var title: String { get }
    var body: String { get }
    var name: String { get }
    var contentView: AnyView { get }
    var contentViewPublisher: AnyPublisher<AnyView, Never> { get }

    func startAnimation()
}

extension OnboardingSlideViewModelInterface {
    public var contentViewPublisher: AnyPublisher<AnyView, Never> {
        Empty<AnyView, Never>().eraseToAnyPublisher()
    }
}
