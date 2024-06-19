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

struct ContentView: View {
    @State private var navigationPath : [Navigation] = []
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(sortDescriptors: [])
    var tasks : FetchedResults<Tasks>

    var body: some View {
        NavigationStack(path: $navigationPath){

            HomeView(navigationPath: $navigationPath)
                .toolbar(){
                    ToolbarItem(placement: .topBarTrailing){
                        Button(){
                            navigationPath.append(.addTask)
                        }label: {
                            Image(systemName: "plus")

                        }
                    }
                    ToolbarItem(placement: .topBarLeading){
                        Button(){
                            deleteAll()
                        }label: {
                            Image(systemName: "gearshape")
                                

                        }
                    }
                }
                .navigationTitle("現在のタスク")
                .navigationDestination(for: Navigation.self){ value in

                    switch value {
                    case .calendar:
                        CalendarView(navigationPath: $navigationPath)
                    case .addTask:
                        AddTaskView(navigationPath: $navigationPath)
                            .navigationBarBackButtonHidden()
                            .navigationTitle("新規タスク作成")
                    case .today:
                        TodayProcessView(navigationPath: $navigationPath)
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


    
    }

#Preview {
    ContentView()
}
