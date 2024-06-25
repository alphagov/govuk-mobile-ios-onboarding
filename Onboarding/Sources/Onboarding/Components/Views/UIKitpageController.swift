import Foundation
import UIKit
import SwiftUI

struct UIKitPageControl: UIViewRepresentable {
    @Binding var currentPage: Int
    var numberOfPages: Int

    typealias UIViewType = UIPageControl

    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()

        pageControl.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numberOfPages
        return pageControl
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        if uiView.currentPage != currentPage {
            uiView.currentPage = currentPage
        }
        if uiView.numberOfPages != numberOfPages {
            uiView.numberOfPages = numberOfPages
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $currentPage)
    }

    class Coordinator: NSObject {
        var currentPage: Binding<Int>
        init(value: Binding<Int>) {
            self.currentPage = value
        }
        @objc func valueChanged(_ pageControl: UIPageControl) {
            self.currentPage.wrappedValue = pageControl.currentPage
        }
    }
}
