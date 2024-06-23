//
//  BlurView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//

import Foundation
import SwiftUI

struct BlurView : UIViewRepresentable{

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }

}
