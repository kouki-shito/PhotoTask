//
//  TodayProcessView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI
import Combine
import PhotosUI

struct TodayProcessView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var naviPath : [NaviTask]
    
    @State private var isPresentedCameraView = false
    @State private var image: UIImage?
    @State private var didPages : Int = 0
    @State private var didPageText : String = "0"
    @State private var textMemo : String = ""
    @State private var didFinishTask : Bool = false
    @State private var selectedImage : PhotosPickerItem?
    @State private var isPresentedPhotoPicker = false

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
                            }else if Int64(didPageText) ?? 0 > Int64((naviPath.last?.nowTask!.leftPages)!) {
                                didPageText = String((naviPath.last?.nowTask!.leftPages) ?? 0)
                                didPages = Int(didPageText) ?? 0
                            }else{
                                didPages = Int(didPageText) ?? 0
                            }
                        })
                    Text("/\(naviPath.last?.nowTask?.todayQuota ?? 0) ページ")
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
                    if #available(iOS 17.0, *) {
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
                        .buttonRepeatBehavior(.enabled)
                        .padding(.trailing,50)
                    } else {
                        // Fallback on earlier versions
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
                    }

                    if #available(iOS 17.0, *) {
                        Button(){
                            if didPages < 9999 && didPages < Int64((naviPath.last?.nowTask!.leftPages)!) {
                                didPages += 1
                            }
                        }label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                        }
                        .buttonRepeatBehavior(.enabled)
                        .padding(.leading,50)
                    } else {
                        Button(){
                            if didPages < 9999 && didPages < Int64((naviPath.last?.nowTask!.leftPages)!) {
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
                }
                .padding(.top,15)
                .frame(maxWidth: .infinity,alignment: .center)

                Form{
                    ZStack(alignment:.topLeading) {
                        TextEditor(text: Binding<String>(
                            get: { textMemo },
                            set: { textMemo = String($0.prefix(221)) }
                        ))
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
                        .contentShape(Rectangle())
                }
            }

            ToolbarItem(placement: .navigationBarTrailing){

                Menu{

                    Button(){
                        if !didFinishTask{
                            isPresentedCameraView.toggle()
                        }else{
                            Save()
                        }
                    }label: {

                        HStack{
                            Image(systemName: "camera")
                            Text("写真を撮る")
                                .contentShape(Rectangle())
                        }
                    }

                    Button{
                        isPresentedPhotoPicker.toggle()
                    }label: {

                        HStack{
                            Image(systemName: "photo.on.rectangle")
                            Text("ギャラリーから選ぶ")
                                .contentShape(Rectangle())
                        }
                    }
                }label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.medium)
                        .padding(.trailing,5)
                        .contentShape(Rectangle())
                }
                .disabled(didPages > 0 ? false: true)
            }

        }
        .onAppear(){

            didFinishTask = false

            for i in naviPath.last?.nowTask?.todaysArray ?? [] {

                if i.updateDate == naviPath.last?.selectingDate{
                    didPages = Int(i.todayProgress)
                    textMemo = i.dailyMemo ?? ""
                    didFinishTask = true
                }
            }
        }
        .onChange(of: image){ _ in
            if image != nil{
                Save()
            }
        }
        .onChange(of: selectedImage) { img in

            Task {
                guard let data = try? await img?.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data: data) else { return }
                image = uiImage
            }
        }
        .onChange(of: textMemo){ _ in
            print(textMemo)
        }
        .fullScreenCover(isPresented: $isPresentedCameraView){
            CameraView(image: $image).ignoresSafeArea()
        }
        .photosPicker(isPresented: $isPresentedPhotoPicker, selection: $selectedImage )
        .edgeSwipe()
    }
    
}

extension TodayProcessView{

    func getPercentage() -> Double{
        if didPages <= naviPath.last?.nowTask?.todayQuota ?? 0{
            return Double(didPages) / Double(naviPath.last?.nowTask?.todayQuota ?? 0)
        }else{
            return 1.0
        }
    }

    func Save(){
        if naviPath.last?.nowTask?.taskState == "進行中"{
            
            for i in naviPath.last?.nowTask?.todaysArray ?? [] {

            if i.updateDate == naviPath.last?.selectingDate{

                i.todayProgress = Int64(didPages)

                do{
                    try viewContext.save()
                    print("Update Success")
                    dismiss()
                }catch{
                    print("Update Error!")
                }
                return;
            }

        }

        let newToday = TodaysTask(context: viewContext)
        newToday.updateDate = naviPath.last?.selectingDate
        newToday.todayProgress = Int64(didPages)
        newToday.dailyPhoto = image!.pngData()
        newToday.dailyMemo = textMemo

        naviPath.last?.nowTask?.addToTodays(newToday)

        if (naviPath.last?.nowTask!.leftPages)! <= Int64(didPages){
            naviPath.last?.nowTask?.taskState = "終了"
        }

        do{
            try viewContext.save()
            print("Save Success")
            dismiss()
        }catch{
            print("Saving Error!")
        }
    }
    }


}

#Preview {
    TodayProcessView(naviPath: .constant([NaviTask(path: .calendar, nowTask: nil),NaviTask(path: .today, nowTask: nil)]))
}
