//
//  TutorialC.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/25.
//

import SwiftUI

struct TutorialC: View {
    
    var body: some View {

        

        VStack(spacing:25){
            Image("\(Tutorial.imgAtoG[3])")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity,alignment: .center)
            Text("\(Tutorial.descriptionAtoG[2])")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
        .padding(.horizontal)
        .padding(.top)


    }
}

#Preview {
    TutorialC()
}