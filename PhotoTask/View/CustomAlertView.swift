//
//  CustomAlertView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//

import Foundation
import SwiftUI

struct CustomAlertView : View {

    @Binding var showAlert : Bool

    var body: some View{

        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            
            VStack(spacing:15){

                Image("trophy")
                    .resizable()
                    .scaledToFit()

                Text("全てのタスクが完了しました！")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("よく頑張りました！成果を確認しましょう!")
                Button(){
                    withAnimation{
                        showAlert.toggle()
                    }

                }label: {
                    Text("カレンダーに戻る")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding(.vertical,10)
                        .padding(.horizontal,25)
                        .background(.accent)
                        .clipShape(Capsule())
                }

            }
            .padding(.vertical,25)
            .padding(.horizontal,30)
            .background(BlurView())
            .clipShape(RoundedRectangle(cornerRadius: 25))

            Button(){
                
                withAnimation{

                    showAlert.toggle()

                }

            }label: {

                Image(systemName: "xmark.circle")
                    .font(.system(size: 28,weight: .bold))
                    .foregroundStyle(.accent)

            }
            .padding()

        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.35)
                
        )
    }

}
