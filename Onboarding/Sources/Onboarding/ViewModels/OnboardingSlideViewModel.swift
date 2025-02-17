import Foundation
import SwiftUICore

import Combine

public protocol OnboardingSlideViewModelInterface: ObservableObject {
    var title: String { get }
    var body: String { get }
    var name: String { get }
    var contentView: AnyView { get }
    var contentViewUpdatePublisher: AnyPublisher<AnyView, Never> { get }

    func willShow()
}

extension OnboardingSlideViewModelInterface {
    public var contentViewUpdatePublisher: AnyPublisher<AnyView, Never> {
        Empty<AnyView, Never>().eraseToAnyPublisher()
    }
}
