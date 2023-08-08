//
//  PreviewContainer.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

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
#endif
