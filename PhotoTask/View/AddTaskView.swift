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

    @Binding var navigationPath : [NaviTask]
    @State var taskNameField : String = ""
    @State var selectStartDate : Date = Date().startOfDay
    @State var selectEndDate : Date = Date().startOfDay.nextDay
    @State var sliderPageNum : Double = 0
    @State var isSliderEditting : Bool = false
    @State var pageField : String = "0"
    @State var isdayPageSetting : DayBool = DayBool(

        monday: true,
        tuesday: true,
        wednesday: true,
        thursday: true,
        friday: true,
        saturday: true,
        sunday: true

    )

    let UIIFGeneratorLight = UIImpactFeedbackGenerator(style: .light)
    let UISFGenerator = UISelectionFeedbackGenerator()

    var body: some View {

        ZStack {

            Color.gray.opacity(0.1)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()
            ScrollView(.vertical){
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
                                    }
                                }
                                .frame(maxWidth: .infinity,alignment: .trailing)
                            }
                        }

                    Divider()

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

                    VStack {
                        Text("学習できる曜日の設定")
                            .font(.title3)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .bold()
                            .padding(.top,10)




                        Toggle(isOn: $isdayPageSetting.monday) {
                            Text("月曜日")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.heavy)
                                .foregroundColor(isdayPageSetting.monday ? .blue : .black.opacity(0.3))
                                .frame(maxWidth: .infinity,alignment: .leading)

                        }
                        .padding(.leading,10)
                        .padding(.top,10)
                        .toggleStyle(.switch)

                        Toggle(isOn: $isdayPageSetting.tuesday) {
                            Text("火曜日")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.heavy)
                                .foregroundColor(isdayPageSetting.tuesday ? .blue : .black.opacity(0.3))
                                .frame(maxWidth: .infinity,alignment: .leading)

                        }
                        .padding(.leading,10)
                        .padding(.top,10)
                        .toggleStyle(.switch)

                        Toggle(isOn: $isdayPageSetting.wednesday) {
                            Text("水曜日")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.heavy)
                                .foregroundColor(isdayPageSetting.wednesday ? .blue : .black.opacity(0.3))
                                .frame(maxWidth: .infinity,alignment: .leading)

                        }
                        .padding(.leading,10)
                        .padding(.top,10)
                        .toggleStyle(.switch)

                        Toggle(isOn: $isdayPageSetting.thursday) {
                            Text("木曜日")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.heavy)
                                .foregroundColor(isdayPageSetting.thursday ? .blue : .black.opacity(0.3))
                                .frame(maxWidth: .infinity,alignment: .leading)

                        }
                        .padding(.leading,10)
                        .padding(.top,10)
                        .toggleStyle(.switch)

                        Toggle(isOn: $isdayPageSetting.friday) {
                            Text("金曜日")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.heavy)
                                .foregroundColor(isdayPageSetting.friday ? .blue : .black.opacity(0.3))
                                .frame(maxWidth: .infinity,alignment: .leading)

                        }
                        .padding(.leading,10)
                        .padding(.top,10)
                        .toggleStyle(.switch)

                        Toggle(isOn: $isdayPageSetting.saturday) {
                            Text("土曜日")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.heavy)
                                .foregroundColor(isdayPageSetting.saturday ? .blue : .black.opacity(0.3))
                                .frame(maxWidth: .infinity,alignment: .leading)

                        }
                        .padding(.leading,10)
                        .padding(.top,10)
                        .toggleStyle(.switch)

                        Toggle(isOn: $isdayPageSetting.sunday) {
                            Text("日曜日")
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.heavy)
                                .foregroundColor(isdayPageSetting.sunday ? .blue : .black.opacity(0.3))
                                .frame(maxWidth: .infinity,alignment: .leading)

                        }
                        .padding(.leading,10)
                        .padding(.top,10)
                        .toggleStyle(.switch)
                    }
                    .padding(.leading,5)
                    .frame(maxWidth: .infinity,alignment: .leading)

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
                }
            }

            ToolbarItem(placement: .navigationBarTrailing){

                Button(){
                    taskSave()

                }label: {
                    Text("保存")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding(.trailing,5)
                }
                .disabled(checkInvaild())
            }
        }
    }
}

extension AddTaskView{

    func taskSave(){

        let newTask = Tasks(context: viewContext)

        newTask.tasksID = UUID()
        newTask.taskName = taskNameField
        newTask.taskStartDate = selectStartDate
        newTask.taskEndDate = selectEndDate
        newTask.goalPages = Int64(pageField)!
        newTask.taskState = "progress"
        newTask.progressPages = 0

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
    AddTaskView(navigationPath: .constant([NaviTask(path: .addTask, nowTask: nil)]))
}
