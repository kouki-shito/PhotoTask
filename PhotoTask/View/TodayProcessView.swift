//
//  TodayProcessView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI
import Combine

struct TodayProcessView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath : [NaviTask]
    
    @State private var isPresentedCameraView = false
    @State private var image: UIImage?
    @State private var didPages : Int = 0
    @State private var didPageText : String = "0"
    @State private var textMemo : String = ""

    @FetchRequest(sortDescriptors: [])
    var tasks : FetchedResults<Tasks>

    var body: some View {

        VStack(){
            Spacer()
            Text("よく頑張りました!")
                .font(.title2)
                .fontWeight(.bold)
            Text("今日の成果を報告しましょう")
                .font(.callout)

                HStack(spacing:0){
                    
                    TextField("",text: $didPageText)
                        .keyboardType(.numberPad)
                        .fontWeight(.bold)
                        .font(.title2)
                        .monospaced()
                        .padding(.top)
                        .frame(width: 70,alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .onChange(of:didPages){ _ in
                            didPageText = String(didPages)
                        }
                        .onReceive(Just(didPageText), perform: { _ in
                            if didPageText.count > 4{
                                didPageText = String(didPageText.prefix(4))
                            }else{
                                didPages = Int(didPageText) ?? 0
                            }
                        })
                    Text("/\(navigationPath.last?.nowTask?.todayQuota ?? 0) ページ")
                        .fontWeight(.bold)
                        .font(.title2)
                        .monospaced()
                        .padding(.top)
                }

                ProgressView(value: getPercentage() )
                    .tint(.green)
                    .background(.red.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .scaleEffect(x: 1, y: 2)
                    .padding(.horizontal)
                HStack{
                    Button(){
                        if didPages != 0 {
                            didPages -= 1
                        }
                    }label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                    }
                    .padding(.trailing,50)
                    Button(){
                        if didPages < 9999 {
                            didPages += 1
                        }
                    }label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                    }
                    .padding(.leading,50)
                }
                .padding(.top,15)
                .frame(maxWidth: .infinity,alignment: .center)

                Form{
                    ZStack(alignment:.topLeading) {
                        TextEditor(text: $textMemo)

                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).opacity(0.2))
                            .frame(maxWidth: .infinity,minHeight: 200)
                        if self.textMemo.isEmpty {
                            HStack {
                                Text("気になることを入力してみよう").opacity(0.25)
                                    .padding()
                                    .padding(.top,8)

                            }
                        }
                    }
                }

                .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
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
                }
            }

            ToolbarItem(placement: .navigationBarTrailing){

                Button(){
                    isPresentedCameraView.toggle()


                }label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.medium)
                        .padding(.trailing,5)
                }

            }
        }
        .onAppear(){
            for i in navigationPath.last?.nowTask?.todaysArray ?? [] {

                if i.updateDate == navigationPath.last?.selectingDate{
                    didPages = Int(i.todayProgress)
                }

            }
        }
        .onChange(of: image){ _ in
            if image != nil{
                Save()
                dismiss()
            }
        }
        .fullScreenCover(isPresented: $isPresentedCameraView){
            CameraView(image: $image).ignoresSafeArea()
        }
    }
    
}

extension TodayProcessView{

    func getPercentage() -> Double{
        if didPages <= navigationPath.last?.nowTask?.todayQuota ?? 0{
            return Double(didPages) / Double(navigationPath.last?.nowTask?.todayQuota ?? 0)
        }else{
            return 1.0
        }
    }

    func Save(){
        
        for i in navigationPath.last?.nowTask?.todaysArray ?? [] {

            if i.updateDate == navigationPath.last?.selectingDate{

                i.todayProgress = Int64(didPages)

                do{
                    try viewContext.save()
                    print("Update Success")
                }catch{
                    print("Update Error!")
                }
                return;
            }

        }

        let newToday = TodaysTask(context: viewContext)
        newToday.updateDate = navigationPath.last?.selectingDate
        newToday.todayProgress = Int64(didPages)
        newToday.dailyPhoto = image?.pngData()

        navigationPath.last?.nowTask?.addToTodays(newToday)

        do{
            try viewContext.save()
            print("Save Success")
        }catch{
            print("Saving Error!")
        }

    }


}

#Preview {
    TodayProcessView(navigationPath: .constant([NaviTask(path: .calendar, nowTask: nil),NaviTask(path: .today, nowTask: nil)]))
}
