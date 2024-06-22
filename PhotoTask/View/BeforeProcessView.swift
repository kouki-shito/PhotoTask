//
//  BeforeProcessView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI

struct BeforeProcessView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var naviPath : [NaviTask]
    @State private var textMemo : String = ""
    @State private var TodaysStatus : Bool = false

    @FetchRequest(sortDescriptors: [])
    var tasks : FetchedResults<Tasks>

    var body: some View {

        ScrollView(.vertical) {

            VStack(spacing:0){

                    HStack(spacing:0){
                        Spacer()
                        Text("Before")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.trailing,80)
                        Spacer()
                        Text("After")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.vertical,10)

                    HStack{

                        RoundedRectangle(cornerRadius: 10)
                            .scaledToFit()
                            .foregroundStyle(.black.opacity(0.1))
                            .overlay(alignment: .center){
                                if let date = naviPath.last?.selectingDate{
                                    if let photo = naviPath.last?.nowTask?.backPhotoData(day: date.yesterday){
                                        Image(uiImage: photo)
                                            .resizable()
                                            .scaledToFill()
                                    }
                                }
                            

                            }
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Image(systemName: "arrowshape.right.fill")

                        RoundedRectangle(cornerRadius: 10)
                            .scaledToFit()
                            .foregroundStyle(.black.opacity(0.1))
                            .overlay(alignment: .center){
                                if let date = naviPath.last?.selectingDate{
                                    if let photo = naviPath.last?.nowTask?.backPhotoData(day: date){
                                        Image(uiImage: photo)
                                            .resizable()
                                            .scaledToFill()
                                    }
                                }

                            }
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                VStack(spacing:0){
                        Text("この日の成果は")
                            .font(.title)
                            .fontWeight(.light)

                        HStack(spacing:0) {
                            Spacer()
                            Text("\(naviPath.last?.todayTask?.todayProgress ?? 0)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .monospaced()
                                .lineLimit(1)
                            Text("ページ")
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top,5)
                                .padding(.leading,5)
                                .lineLimit(1)
                            Spacer()
                        }
                        .background(Capsule().foregroundStyle(.black.opacity(0.1)))
                        .padding(.vertical,10)
                        .padding(.horizontal,90)
                        .frame(maxWidth: .infinity)

                        Text("よく頑張りました！")
                            .font(.title)
                            .fontWeight(.light)

                    }
                    .frame(maxWidth:.infinity,alignment: .center)
                    .padding(.top,30)
                    .padding(.bottom,10)

                    VStack{
                        ZStack(alignment:.topLeading) {
                            TextEditor(text: Binding<String>(
                                get: { textMemo },
                                set: { textMemo = String($0.prefix(228)) }
                            ))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).opacity(0.2))
                                .frame(maxWidth: .infinity,minHeight: 200)
                                .disabled(!TodaysStatus)
                        }
                        .contentShape(Rectangle())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,20)
                    .padding(.top,30)
                    .scrollContentBackground(.hidden)


                }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .onAppear(){
            TodaysStatus = false
            if let todayTask = naviPath.last?.todayTask{
                TodaysStatus = true
                textMemo = todayTask.dailyMemo ?? ""
            }

        }
        .toolbar(){

            ToolbarItem(placement: .navigationBarLeading){

                Button(){
                    dismiss()
                }label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .fontWeight(.medium)
                        .padding(.leading,5)
                        .contentShape(Rectangle())
                }
            }

            ToolbarItem(placement: .navigationBarTrailing){

                Button(){
                    save()
                }label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.medium)
                        .padding(.trailing,5)
                        .contentShape(Rectangle())

                }
                .disabled(!TodaysStatus)
            }

        }
        .edgeSwipe()

    }
}

extension BeforeProcessView{

    func save(){
        
        if let todayTask = naviPath.last?.todayTask{

            if todayTask.dailyMemo != textMemo{

                todayTask.dailyMemo = textMemo

                do{
                    try viewContext.save()
                    print("Update Success")
                    dismiss()
                }catch{
                    print("Update Error!")
                }
            }
        }


    }
}

#Preview {
    BeforeProcessView(naviPath: .constant([NaviTask(path: .calendar, nowTask: nil),NaviTask(path: .before, nowTask: nil)]))
}
