//
//  HomeView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var naviPath : [NaviTask]

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Tasks.taskState, ascending: false),
        NSSortDescriptor(keyPath: \Tasks.taskEndDate, ascending: true)
    ])
    private var tasks : FetchedResults<Tasks>

    var body: some View {
        ZStack{
            Color.gray.opacity(0.1)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()
            
            List(){
                ForEach(tasks){ i in
                    Section {
                        HStack(spacing:0){
                            RoundedRectangle(cornerRadius: 20)
                                .scaledToFit()
                                .frame(width: 80)
                                .overlay(alignment: .center){
                                    if let photo = i.thumbnailPhoto{
                                        Image(uiImage: UIImage(data: photo)!)
                                            .resizable()
                                            .scaledToFill()
                                    }
                                }
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.trailing,5)
                            VStack(spacing:0) {

                                //MARK: - name and left
                                HStack(spacing:0) {

                                    Text(i.taskName ?? "")//MAX3
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.headline)
                                        .bold()
                                        .padding(.bottom,5)
                                        .lineLimit(3)

                                    Spacer()

                                    VStack {
                                        HStack(spacing:0){
                                            Text("期限まであと")
                                                .fixedSize(horizontal: true, vertical: false)
                                                .font(.caption2)
                                                .padding(.leading,1)
                                                .padding(.trailing,3)
                                            Text("\(i.leftDay)") //MAX4
                                                .fixedSize(horizontal: false, vertical: true)
                                                .bold()
                                                .foregroundStyle(i.leftDay <= 3 ? .red : .black)
                                                .font(.caption)
                                                .lineLimit(1)
                                                .padding(.trailing,3)
                                            Text("日")
                                                .fixedSize(horizontal: true, vertical: false)
                                                .font(.caption2)
                                        }
                                        .padding(.top)
                                        .padding(.bottom)
                                        .frame(maxHeight: 20)
                                    }

                                }

                                Divider()

                                HStack(spacing:0) {

                                    if i.leftPages > 0{
                                        
                                        Text("あと\(i.leftPages)ページ")
                                            .fixedSize(horizontal: true, vertical: true)
                                            .font(.caption2)
                                            .padding(.top)
                                            .padding(.bottom,5)
                                            .lineLimit(1)

                                    }else{
                                        Text("完了")
                                            .fixedSize(horizontal: true, vertical: true)
                                            .font(.caption2)
                                            .padding(.top)
                                            .padding(.bottom,5)
                                            .bold()
                                            .padding(.leading,2)
                                            .lineLimit(1)
                                    }

                                    Spacer()

                                    HStack(spacing:0) {
                                        if checkTodayProgress(tasks: i) != 0{

                                            Image(systemName: "checkmark.circle.fill")
                                                .fixedSize(horizontal: true, vertical: false)
                                                .foregroundStyle(.green)
                                                .font(.caption2)
                                                .padding(.trailing,5)
                                                .padding(.top)
                                                .padding(.bottom,5)
                                        }

                                        Text(checkTodayProgress(tasks: i) != 0 ? "完了" : "本日のノルマ")
                                            .fixedSize(horizontal: true, vertical: false)
                                            .font(.caption2)
                                            .padding(.trailing,5)
                                            .padding(.top)
                                            .padding(.bottom,5)
                                            .lineLimit(1)

                                        HStack(spacing:0) {
                                            Text(checkTodayProgress(tasks: i) != 0 ? "\(checkTodayProgress(tasks: i))" : "\(i.todayQuota)")//MAX 7
                                                .fixedSize(horizontal: true, vertical: false)
                                                .font(.callout)
                                                .bold()
                                                .padding(.top)
                                                .padding(.bottom,5)
                                            Text("P")
                                                .fixedSize(horizontal: true, vertical: false)
                                                .font(.callout)
                                                .bold()
                                                .padding(.top)
                                                .padding(.bottom,5)
                                        }
                                    }

                                }

                                ProgressView(value: i.progressPercent)
                                    .progressViewStyle(.linear)

                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal,6)

                        }
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.white))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal,2)
                        .padding(.vertical,2)
                        .onTapGesture {
                            naviPath.append(NaviTask(path: .calendar, nowTask: i))
                        }
                    } header: {
                        HStack(spacing:0){
                            backToIconStateImg(state: i.taskState!)
                                .foregroundStyle(backToIconStateColor(state: i.taskState!))
                            Text(i.taskState!)
                        }
                    }


                }

                .onDelete(perform: deleteTask)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal,2)
            .scrollContentBackground(.hidden)
            .listRowSpacing(10)

        }
        .onAppear(){

            for i in tasks{
                if i.taskState == "進行中"{
                if i.taskEndDate ?? Date.now.startOfDay < Date.now.startOfDay || i.leftPages <= 0{
                    i.taskState = "終了"

                    do{
                        try viewContext.save()
                        print("Update State Success")

                    }catch{
                        print("Update State Error!")
                    }

                }
                i.addProgressPages()
            }
            }

        }
    }
}

extension HomeView{

    func deleteTask(offsets : IndexSet){
        for index in offsets {
            let deleteData = tasks[index]
            viewContext.delete(deleteData)
        }
        do{
            try viewContext.save()
            print("delete Success")
        }catch{
            print("delete Error!")
        }
    }

    func checkTodayProgress(tasks : Tasks) -> Int{

        for i in tasks.todaysArray{
            if i.updateDate == Date.now.startOfDay{
                return Int(i.todayProgress)
            }
        }
        return 0
    }

    func backToIconStateImg(state : String) -> Image{
        switch state{
        case "進行中":
            return Image(systemName: "flag.fill")
        case "終了":
            return Image(systemName: "tray.fill")
        case "休止":
            return Image(systemName: "zzz")
        default:
            return Image(systemName: "exclamationmark.triangle.fill")
        }
    }
    func backToIconStateColor(state : String) -> Color{
        switch state{
        case "進行中":
            return .green
        case "終了":
            return .blue
        case "休止":
            return .white
        default:
            return .yellow
        }
    }
}

#Preview {
    HomeView(naviPath: .constant([]))
}
