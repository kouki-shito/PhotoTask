//
//  VersionExtention.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/20.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func onChange<V: Equatable>(of value: V, initial: Bool, perform action: @escaping (_ newValue: V) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            onChange(of: value, initial: initial) {
                action($1)
            }
        } else if initial {
            onAppear { action(value) }
                .onChange(of: value, perform: action)
        } else {
            onChange(of: value, perform: action)
        }
    }
}
