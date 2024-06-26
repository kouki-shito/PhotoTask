//
//  TutorialG.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/25.
//

import SwiftUI

struct TutorialG: View {
    var body: some View {

        VStack(spacing:25){

            HStack(spacing:10){

                Image("\(Tutorial.imgAtoG[10])")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity,alignment: .center)
                Image("\(Tutorial.imgAtoG[11])")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity,alignment: .center)
            }

            Text("\(Tutorial.descriptionAtoG[6])")
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
    TutorialG()
}
