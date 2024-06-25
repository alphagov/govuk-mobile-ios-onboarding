import Foundation
import SwiftUI

struct AdaptiveStack<Content: View>: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let spaceing: CGFloat
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let content: () -> Content

    init(spaceing: CGFloat,
         horizontalAlignment: HorizontalAlignment = .center,
         verticalAlignment: VerticalAlignment = . center,
         @ViewBuilder content: @escaping () -> Content) {
        self.spaceing = spaceing
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.content = content
    }

    var body: some View {
        Group {
            if  verticalSizeClass == .compact {
                HStack(alignment: verticalAlignment, content: content)
            } else {
                VStack(alignment: horizontalAlignment, content: content)
            }
        }
    }
}
