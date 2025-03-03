import Foundation
import SwiftUI

@testable import Onboarding

class MockSlideViewModel: OnboardingSlideViewModelInterface,
                          Equatable {

    var title: String
    var body: String = "Body"
    var name: String
    var contentView: AnyView = AnyView(EmptyView())
    var primaryButtonTitle: String
    var primaryButtonAccessibilityHint: String? = nil
    var secondaryButtonTitle: String = "Secondary"
    var secondaryButtonAccessibilityHint: String? = nil

    init(title: String = "Title",
         name: String = "Name",
         primaryButtonTitle: String = "Primary") {
        self.title = title
        self.name = name
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAccessibilityHint = primaryButtonTitle + " accessibility hint"
        self.secondaryButtonAccessibilityHint = secondaryButtonTitle + " accessibility hint"
    }

    func didAppear() { }

    static func == (lhs: MockSlideViewModel, rhs: MockSlideViewModel) -> Bool {
        lhs.title == rhs.title &&
        lhs.name == rhs.name &&
        lhs.body == rhs.body &&
        lhs.primaryButtonTitle == rhs.primaryButtonTitle &&
        lhs.secondaryButtonTitle == rhs.secondaryButtonTitle
    }
}
