//
//  tutorialChildView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//

import SwiftUI

struct tutorialChildView: View {
    
    @State var tutorial : Tutorial = Tutorial()
    @State var index : Int

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    tutorialChildView(index: 1)
}
