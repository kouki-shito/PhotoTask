//
//  tutorialView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//

import SwiftUI

struct Tutorial{

    let Imgtitle : [String] = ["problem","study","woman","bookBoy"]
    let titleText : [String] = [""]
    let description : [String] = [""]

}

struct tutorialView: View {

    var body: some View {
        TabView{

            ForEach(0..<5){ index in
                
                tutorialChildView(index: index)

            }

        }
        .tabViewStyle(.page)
    }
}

#Preview {
    tutorialView()
}
