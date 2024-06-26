//
//  AddTaskView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI
import AudioToolbox
import Combine
import CoreData
import PhotosUI

struct DayBool{

    var monday : Bool

    var tuesday :Bool

    var wednesday : Bool

    var thursday : Bool

    var friday : Bool

    var saturday : Bool

    var sunday : Bool

}

struct AddTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @FocusState var isFocused : Bool

    @Binding var naviPath : [NaviTask]
    @State private var taskNameField : String = ""
    @State private var selectStartDate : Date = Date.now.startOfDay
    @State private var selectEndDate : Date = Date.now.startOfDay.nextDay
    @State private var sliderPageNum : Double = 0
    @State private var isSliderEditting : Bool = false
    @State private var pageField : String = "0"
    @State private var image: UIImage?
    @State private var selectedImage : PhotosPickerItem?
    @State private var isPresentedPhotoPicker = false
    @State private var isPresentedCameraView = false

    private let UIIFGeneratorLight = UIImpactFeedbackGenerator(style: .light)
    private let UISFGenerator = UISelectionFeedbackGenerator()

    var body: some View {

        ZStack {

            Color.gray.opacity(0.1)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()

            ScrollView(.vertical){
                //MARK: - Task Name Section
                VStack{

                    TextField("タスク名称", text: $taskNameField)
                        .font(.title)
                        .fontWeight(.heavy)
                        .focused($isFocused)
                        .toolbar(){
                            ToolbarItemGroup(placement: .keyboard){
                                HStack{
                                    Button(){
                                        isFocused.toggle()
                                    }label: {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.green)
                                            .bold()
                                            .contentShape(Rectangle())
                                    }
                                }
                                .frame(maxWidth: .infinity,alignment: .trailing)
                            }
                        }
                    
                    Divider()

                    //MARK: - Task Date Section

                    HStack(spacing:0) {
                        Text("期間")
                            .font(.title3)
                            .padding(.leading,5)
                            .bold()

                        Spacer()
                        DatePicker(
                            "Date",
                            selection: $selectStartDate,
                            in: Date()..., displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .disabled(true)


                        .datePickerStyle(.compact)
                        Text("〜")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.leading,10)
                            .fixedSize()

                        DatePicker(
                            "Date",
                            selection: $selectEndDate,
                            in: Calendar.current.date(byAdding: .day, value: 1, to: selectStartDate)!..., displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .padding(.leading,10)
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .datePickerStyle(.compact)
                        .onChange(of: selectEndDate){ _ in
                            print(selectEndDate)
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top,10)

                    Divider()
                    
                    //MARK: - Pages Section

                    HStack(spacing:0){

                        Text("ページ数")
                            .font(.title3)
                            .padding(.leading,3)
                            .bold()
                        Spacer()

                        HStack(spacing:0) {

                            Slider(value: $sliderPageNum,
                                   in: 0...999,
                                   step: 1,
                                   onEditingChanged: { editting in
                                isSliderEditting = editting
                            }
                            )
                            .padding(.leading,10)
                            .padding(.trailing,30)
                            .onChange(of:sliderPageNum){ _ in
                                if isSliderEditting {
                                    UISFGenerator.selectionChanged()
                                }
                            }
                            TextField("4桁",text: $pageField)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.title3)
                                .monospaced()
                                .bold()
                                .focused($isFocused)
                                .onChange(of:sliderPageNum){ _ in
                                    pageField = String(Int(sliderPageNum))
                                }
                                .onReceive(Just(pageField), perform: { _ in
                                    if pageField.count > 4{
                                        pageField = String(pageField.prefix(4))
                                    }else{
                                        sliderPageNum = Double(pageField) ?? 0
                                    }
                                })
                                .padding(.trailing,10)
                                .frame(width: 50,alignment: .trailing)
                                .keyboardType(.numberPad)

                        }

                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top,10)

                    Divider()

                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)

            .background(Rectangle().foregroundStyle(.white))

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

                Menu{

                    Button(){
                        isPresentedCameraView.toggle()
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
                    Text("保存")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding(.trailing,5)
                        .contentShape(Rectangle())
                }
                .disabled(checkInvaild())
            }
        }
        .fullScreenCover(isPresented: $isPresentedCameraView){
            CameraView(image: $image).ignoresSafeArea()
        }
        .photosPicker(isPresented: $isPresentedPhotoPicker, selection: $selectedImage )
        .onChange(of: image){ _ in
            if image != nil{
                taskSave()
            }
        }
        .onChange(of: selectedImage) { img in

            Task {
                guard let data = try? await img?.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data: data) else { return }
                image = uiImage
            }
        }
    }
}

//MARK: -Extent Func Section

extension AddTaskView{

    func taskSave(){

        let newTask = Tasks(context: viewContext)

        newTask.tasksID = UUID()
        newTask.taskName = taskNameField
        newTask.taskStartDate = selectStartDate
        newTask.taskEndDate = selectEndDate
        newTask.goalPages = Int64(pageField)!
        newTask.taskState = "進行中"
        newTask.progressPages = 0
        newTask.thumbnailPhoto = image!.pngData()
        newTask.isCongrated = false

        do{
            try viewContext.save()
            dismiss()
            print("Save Success")
        }catch{
            print("Saving Error!")
        }
        
    }

    func checkInvaild() -> Bool{
        
        if Int(pageField) != 0 && taskNameField != ""{
            return false
        }
        return true
    }

}



#Preview {
    AddTaskView(naviPath: .constant([NaviTask(path: .addTask, nowTask: nil)]))
}
