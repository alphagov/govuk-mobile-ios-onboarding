import Foundation
import UIKit
import SwiftUI

struct UIKitPageControl: UIViewRepresentable {
    @Binding var currentPage: Int
    var numberOfPages: Int

    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numberOfPages
        pageControl.backgroundStyle = .prominent

        if #available(iOS 16.0, *) {
            let pageIndicator = UIImage(systemName: "circle")
            let currentPageIndicator = UIImage(systemName: "circle.fill")
            pageControl.preferredIndicatorImage = pageIndicator
            pageControl.pageIndicatorTintColor = UIColor.govUK.strokes.pageControlInactive
            pageControl.preferredCurrentPageIndicatorImage = currentPageIndicator
            pageControl.currentPageIndicatorTintColor = UIColor.govUK.fills.surfaceButtonPrimary
        }
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
