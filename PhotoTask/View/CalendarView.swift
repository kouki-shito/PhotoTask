//
//  CalendarView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI

struct CalendarView: View {

    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) private var dismiss

    @Binding var naviPath : [NaviTask]
    @State private var days : [Date] = []
    @State private var date : Date = Date.now
    @State private var progressTemp : Int64 = 0
    @State var customAlert = false

    private let formatter = DateFormatter()
    private let daysOfWeek = ["日","月","火","水","木","金","土"]
    private let columns = Array(repeating: GridItem(.flexible(),spacing: 0), count: 7)

    var body: some View {

        let navtask = naviPath.last?.nowTask

        ZStack {

            Color.gray.opacity(0.1)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()

            VStack {

                //MARK: - Day Of Week Section

                Divider()
                    .frame(maxWidth: .infinity)

                HStack {
                    ForEach(daysOfWeek.indices,id: \.self){ i in
                        Text(daysOfWeek[i])
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(i == 0 || i == 6 ? .red : .black)
                    }
                }
                .padding(.top,5)

                //MARK: - Calendar Grid Section

                LazyVGrid(columns:columns,spacing: 0){

                    ForEach(days,id: \.self){ day in
                        if day.monthInt != date.monthInt {
                            Text("")
                                .border(Color.gray.opacity(0.1))
                                .font(.subheadline)
                                .fontWeight(.light)
                                .frame(maxWidth: .infinity,minHeight: 80,alignment: .topLeading)
                                .padding(.top,5)
                                .monospaced()
                                .padding(.leading,8)
                                .border(Color.gray.opacity(0.1))
                        }else{
                            ZStack{
                                Rectangle()
                                    .overlay(alignment: .topLeading) {
                                        Text(day.formatted(.dateTime.day()))
                                            .font(.subheadline)
                                            .fontWeight(.light)
                                            .foregroundStyle(Date.now.startOfDay == day.startOfDay ? .blue : .black)
                                            .frame(maxWidth: .infinity,minHeight: 80,alignment: .topLeading)
                                            .padding(.top,5)
                                            .monospaced()
                                            .padding(.leading,8)

                                    }
                                    .overlay(alignment: .center) {
                                        if getPhoto(day: day) != nil{
                                            Image(uiImage: getPhoto(day: day)!)
                                                .resizable()
                                                .scaledToFill()
                                        }
                                    }
                                    .foregroundStyle(.clear)
                                    .frame(maxWidth: .infinity, minHeight: 80)
                                    .clipped()

                                Text(navtask?.everydayQuotaArray(day: day) ?? "")

                        }
                            .contentShape(Rectangle())
                            .border(backColor(day: day))
                            .onTapGesture {
                                if Date.now.startOfDay == day.startOfDay && naviPath.last?.nowTask?.taskState == "進行中" {

                                    naviPath.append(NaviTask(
                                        path: .today,
                                        nowTask: naviPath.last?.nowTask,
                                        selectingDate: day))

                                }else if day.startOfDay < Date.now.startOfDay {

                                    naviPath.append(NaviTask(
                                        path: .before,
                                        nowTask: naviPath.last?.nowTask,
                                        selectingDate: day,todayTask: naviPath.last?.nowTask?.backTodays(day: day))
                                    )

                                }

                            }

                        }
                        

                    }

                }


                Spacer()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .contentShape(Rectangle())
            .onAppear(){

                days = date.calendarDisplayDays
                navtask?.addProgressPages()

                if navtask?.taskState == "終了" && navtask?.leftPages == 0 && navtask?.isCongrated == false{
                    navtask?.isCongrated = true

                    do{
                        try viewContext.save()
                        print("Congrat Success")
                        
                        withAnimation{
                            customAlert.toggle()
                        }
                    }catch{
                        print("Congrat Error!")
                    }


                }

            }
            .onChange(of: date) { _ in
                days = date.calendarDisplayDays
        }

            if customAlert {

                CustomAlertView(showAlert: $customAlert)

            }

        }
        .gesture(DragGesture().onEnded { gesture in
            if gesture.translation.width > 0 {
                // swipe to Right
                date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
            } else {
                // swipe to Left
                date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
            }
        })
        .navigationBarTitleDisplayMode(.inline)
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

            ToolbarItem(placement: .principal){
                HStack{

                    Button(){
                        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
                    }label: {
                        Image(systemName: "lessthan")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .contentShape(Rectangle())
                    }
                    
                    Text(getNowYearMonth())
                        .fontWeight(.medium)
                        .monospaced()

                    Button(){
                        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
                    }label: {
                        Image(systemName: "greaterthan")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .contentShape(Rectangle())

                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing){

                Menu{

                    Button(){
                        date = Date.now.startOfDay
                    }label: {

                        HStack{
                            Image(systemName: "arrowshape.turn.up.backward.badge.clock.fill")
                            Text("現在に戻る")
                                .contentShape(Rectangle())
                        }
                    }

                    Button(){
                        date = navtask?.taskStartDate ?? Date.now.startOfDay
                    }label: {
                        HStack{
                            Image(systemName: "bookmark.fill")
                            Text("開始日に戻る")
                                .contentShape(Rectangle())
                        }

                    }

                }label: {
                    Image(systemName: "ellipsis")
                        .padding(.trailing,5)
                }

            }
        }
    }



}

//MARK: -Extent Func Section

extension CalendarView {

    func getPhoto(day : Date) -> UIImage?{

        return naviPath.last?.nowTask?.backPhotoData(day: day)
    }

    func getNowYearMonth() -> String{

        formatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "yMMM",
            options: 0,
            locale: Locale(identifier: "ja_JP"))

        return formatter.string(from: date)

    }

    func backColor(day:Date) -> Color{

        switch day.startOfDay{
        case Date.now.startOfDay:
            return Color.blue.opacity(0.8)
        case naviPath.last?.nowTask?.taskStartDate:
            return Color.red.opacity(0.8)
        case naviPath.last?.nowTask?.taskEndDate:
            return Color.green.opacity(0.8)
        default:
            return Color.gray.opacity(0.1)
        }

    }

}



#Preview {
    CalendarView(naviPath:.constant([NaviTask(path: .calendar, nowTask: nil)]))
}
