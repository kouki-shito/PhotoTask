//
//  tutorialChildView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//

import SwiftUI

struct tutorialChildView: View {

    @State var index : Int

    var body: some View {

        VStack(spacing:25){
            Image("\(Tutorial.Imgtitle[index])")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity,alignment: .center)
            Text("\(Tutorial.titleText[index])")
                .foregroundStyle(.primary)
                .font(.title)
                .bold()
            Text("\(Tutorial.description[index])")
                .foregroundStyle(.primary)
                .font(.title3)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
        .padding(.horizontal)
        
    }
}

#Preview {
    tutorialChildView(index: 1)
}
