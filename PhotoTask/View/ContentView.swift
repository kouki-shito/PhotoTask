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
    var todayTask : TodaysTask?
}

struct ContentView: View {
    @State private var naviPath : [NaviTask] = []
    @State private var isQuestion : Bool = false
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(sortDescriptors: [])
    private var tasks : FetchedResults<Tasks>

    var body: some View {
        NavigationStack(path: $naviPath){

            HomeView(naviPath: $naviPath)
                .toolbar(){
                    ToolbarItem(placement: .topBarTrailing){
                        Button(){
                            naviPath.append(NaviTask(path: .addTask, nowTask: nil))
                        }label: {
                            Image(systemName: "plus")
                                .bold()
                                .contentShape(Circle())
                            
                        }
                    }
                    ToolbarItem(placement: .topBarLeading){
                        Button(){
                            isQuestion.toggle()
                        }label: {
                            Image(systemName: "questionmark")
                                .bold()
                                .contentShape(Circle())

                        }
                    }
                }
                .navigationTitle("現在のタスク")
                .navigationDestination(for: NaviTask.self){ value in

                    switch value.path {
                    case .calendar:
                        CalendarView(naviPath: $naviPath)
                            .navigationBarBackButtonHidden()
                    case .addTask:
                        AddTaskView(naviPath: $naviPath)
                            .navigationBarBackButtonHidden()
                            .navigationTitle("新規タスク作成")
                            .navigationBarTitleDisplayMode(.inline)
                    case .today:
                        TodayProcessView(naviPath: $naviPath)
                            .navigationBarBackButtonHidden()
                    case .before:
                        BeforeProcessView(naviPath: $naviPath)
                            .navigationBarBackButtonHidden()
                    }
                }
                .fullScreenCover(isPresented: $isQuestion){
                    tutorialView()
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


    }

#Preview {
    ContentView()
}
