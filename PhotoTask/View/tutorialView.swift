//
//  tutorialView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//

import SwiftUI


struct tutorialView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
        VStack{
            Button(){
                dismiss()
            }label: {
                Image(systemName: "xmark")
                    .bold()
                    .contentShape(Circle())
                    .frame(maxWidth: .infinity,alignment: .topLeading)
                    .padding(.leading)
                    .padding(.top,5)
            }
            
            TabView{

                ForEach(0..<4){ index in

                    tutorialChildView(index: index)

                }
                
                TutorialA()
                TutorialB()
                TutorialC()
                TutorialD()
                TutorialE()
                TutorialF()
                TutorialG()

            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }


    }
}

#Preview {
    tutorialView()
}
