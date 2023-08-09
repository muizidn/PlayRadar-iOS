//
//  PreviewContainer.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

/**
 Helper for Xcode 14
 */

#if DEBUG
import SwiftUI
import UIKit

struct PreviewContainer<T: UIView>: UIViewRepresentable {
    let view: T

    init(_ viewBuilder: @escaping () -> T) {
        view = viewBuilder()
    }
    
    func makeUIView(context: Context) -> T {
        return view
    }
    
    func updateUIView(_ uiView: T, context: Context) {
        // Set content hugging priority to maintain layout
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

struct ControllerPreviewContainer<T: UIViewController>: UIViewControllerRepresentable {
    let viewController: T

    init(_ viewControllerBuilder: @escaping () -> T) {
        viewController = viewControllerBuilder()
    }

    func makeUIViewController(context: Context) -> T {
        return viewController
    }

    func updateUIViewController(_ uiViewController: T, context: Context) {
        // No need to implement an update method for UIViewControllers
    }
}
#endif
