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

    @Binding var navigationPath : [NaviTask]
    @State private var days : [Date] = []
    @State private var date : Date = Date.now
    @State private var progressTemp : Int64 = 0
    let formatter = DateFormatter()
    let daysOfWeek = ["日","月","火","水","木","金","土"]
    let columns = Array(repeating: GridItem(.flexible(),spacing: 0), count: 7)


    var body: some View {
        let navtask = navigationPath.last?.nowTask

        ZStack {

            Color.gray.opacity(0.1)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()

            VStack {

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
                                Text(day.formatted(.dateTime.day()))
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .foregroundStyle(Date.now.startOfDay == day.startOfDay ? .blue : .black)
                                    .frame(maxWidth: .infinity,minHeight: 80,alignment: .topLeading)
                                    .padding(.top,5)
                                    .monospaced()
                                    .padding(.leading,8)
                                    .border(backColor(day: day))
                                Text(navtask?.everydayQuotaArray(day: day) ?? "")

                                Image(uiImage:))
                                    .resizable()
                                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if Date.now.startOfDay == day.startOfDay{
                                    navigationPath.append(NaviTask(path: .today,nowTask: navigationPath.last?.nowTask,selectingDate: day))
                                }else if day.startOfDay < Date.now.startOfDay {
                                    navigationPath.append(NaviTask(path: .before,nowTask: navigationPath.last?.nowTask,selectingDate: day))
                                }

                            }
                        }

                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .onAppear(){
                days = date.calendarDisplayDays
                navtask?.addProgressPages()
            }
            .onChange(of: date) { _ in
                days = date.calendarDisplayDays
                
        }
        }
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
                        }
                    }

                    Button(){
                        date = navtask?.taskStartDate ?? Date.now.startOfDay
                    }label: {
                        HStack{
                            Image(systemName: "bookmark.fill")
                            Text("開始日に戻る")
                        }

                    }

                }label: {
                    Image(systemName: "ellipsis")
                        .padding(.trailing,5)
                }

            }
        }
    }

    func getPhoto(day : Date) -> UIImage?{

        return UIImage(data: navigationPath.last?.nowTask?.backPhotoData(day: day) ?? )
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
        case navigationPath.last?.nowTask?.taskStartDate:
            return Color.red.opacity(0.8)
        case navigationPath.last?.nowTask?.taskEndDate:
            return Color.green.opacity(0.8)
        default:
            return Color.gray.opacity(0.1)
        }

    }

}



#Preview {
    CalendarView(navigationPath:.constant([NaviTask(path: .calendar, nowTask: nil)]))
}
