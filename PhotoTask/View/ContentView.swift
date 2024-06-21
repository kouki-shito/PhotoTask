//
//  ContentView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI
import CoreData

enum Navigation {
    case calendar,addTask,today,before
}

struct NaviTask : Hashable {
    var path : Navigation
    var nowTask : Tasks?
    var selectingDate : Date?
}

struct ContentView: View {
    @State private var navigationPath : [NaviTask] = []
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(sortDescriptors: [])
    var tasks : FetchedResults<Tasks>

    var body: some View {
        NavigationStack(path: $navigationPath){

            HomeView(navigationPath: $navigationPath)
                .toolbar(){
                    ToolbarItem(placement: .topBarTrailing){
                        Button(){
                            navigationPath.append(NaviTask(path: .addTask, nowTask: nil))
                        }label: {
                            Image(systemName: "plus")

                        }
                    }
                    ToolbarItem(placement: .topBarLeading){
                        Button(){
                            debugSave()
                        }label: {
                            Image(systemName: "gearshape")
                                

                        }
                    }
                }
                .navigationTitle("現在のタスク")
                .navigationDestination(for: NaviTask.self){ value in

                    switch value.path {
                    case .calendar:
                        CalendarView(navigationPath: $navigationPath)
                            .navigationBarBackButtonHidden()
                    case .addTask:
                        AddTaskView(navigationPath: $navigationPath)
                            .navigationBarBackButtonHidden()
                            .navigationTitle("新規タスク作成")
                            .navigationBarTitleDisplayMode(.inline)
                    case .today:
                        TodayProcessView(navigationPath: $navigationPath)
                            .navigationBarBackButtonHidden()
                    case .before:
                        BeforeProcessView(navigationPath: $navigationPath)
                    }
                }
        }
        
    }

}

extension ContentView{

    func check(){
        for i in tasks{
            print(i.goalPages)
        }
    }
    func deleteAll(){
        for i in tasks{
            viewContext.delete(i)
        }
        do{
            try viewContext.save()
            print("delete Success")
        }catch{
            print("delete Error!")
        }
    }

    func debugSave(){

        let newTask = Tasks(context: viewContext)

        newTask.tasksID = UUID()
        newTask.taskName = "DEBUG!!"
        newTask.taskStartDate = makeDate(y: 2023, m: 6, d: 2)
        newTask.taskEndDate = makeDate(y: 2024, m: 10, d: 10)
        newTask.goalPages = 100
        newTask.taskState = "progress"
        newTask.progressPages = 0

        do{
            try viewContext.save()
            print("Save Success")
        }catch{
            print("Saving Error!")
        }

    }

    func makeDate(y:Int,m:Int,d:Int) -> Date{

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo") ?? TimeZone.gmt

        let date = calendar.date(from: DateComponents(year: y,month: m,day: d))!.startOfDay
        return date
    }


    }

#Preview {
    ContentView()
}
