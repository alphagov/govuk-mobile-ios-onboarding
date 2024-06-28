import Foundation
import SwiftUI
import UIKit

struct UIKitActionButton: UIViewRepresentable {
    typealias UIViewType = UIButton
    var onTap: (() -> Void)
    var title: String
    var backgroundColor: Color
    var textColor: Color

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
         button.backgroundColor = UIColor(backgroundColor)
        button.layer.cornerRadius = 25
        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.handlerTap),
            for: .touchUpInside
        )
        return button
    }

    func updateUIView(_ uiView: UIButton,
                      context: Context) {
        uiView.setTitle(title, for: .normal)
        uiView.backgroundColor = UIColor(backgroundColor)
        uiView.setTitleColor(UIColor(textColor), for: .normal)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    class Coordinator {
         @objc let onTap: (() -> Void)

        init(onTap: @escaping (() -> Void)) {
             self.onTap = onTap
         }

         @objc func handlerTap() {
             onTap()
         }
     }
 }
