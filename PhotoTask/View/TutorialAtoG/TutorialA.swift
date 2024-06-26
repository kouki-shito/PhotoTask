//
//  TutorialA.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/25.
//

import SwiftUI

struct TutorialA: View {

    var body: some View {

        VStack(spacing:25){

            Image("\(Tutorial.imgAtoG[0])")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity,alignment: .center)
            Text("\(Tutorial.descriptionAtoG[0])")
                .font(.title2)
                .foregroundStyle(.primary)
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
    TutorialA()
}
