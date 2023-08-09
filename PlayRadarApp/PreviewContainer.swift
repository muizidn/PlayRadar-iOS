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
    let DashboardViewController: T

    init(_ viewControllerBuilder: @escaping () -> T) {
        DashboardViewController = viewControllerBuilder()
    }

    func makeUIViewController(context: Context) -> T {
        return DashboardViewController
    }

    func updateUIViewController(_ uiViewController: T, context: Context) {
        // No need to implement an update method for UIViewControllers
    }
}

struct RouterPreviewContainer<T: Router>: UIViewControllerRepresentable {
    let router: T

    init(_ routerBuilder: @escaping () -> T) {
        router = routerBuilder()
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return router.launch()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to implement an update method for UIViewControllers
    }
}
#endif
