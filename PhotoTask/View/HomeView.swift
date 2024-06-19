//
//  HomeView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navigationPath : [Navigation]

    @FetchRequest(sortDescriptors: [])
    private var tasks : FetchedResults<Tasks>

    var body: some View {
        ZStack{
            Color.gray.opacity(0.1)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea()

            List(tasks){ i in

                HStack(spacing:0){

                    Image("camp")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 65)
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
                            Text("あと\(i.leftPages)ページ")
                                .fixedSize(horizontal: true, vertical: true)
                                .font(.caption2)
                                .padding(.top)
                                .padding(.bottom,5)
                                .lineLimit(1)

                            Spacer()

                            HStack(spacing:0) {
                                Text("本日のノルマ")
                                    .fixedSize(horizontal: true, vertical: false)
                                    .font(.caption2)
                                    .padding(.trailing,5)
                                    .padding(.top)
                                    .padding(.bottom,5)
                                    .lineLimit(1)

                                HStack(spacing:0) {
                                    Text("\(i.todayQuota)")//MAX 7
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

            }

            .frame(maxWidth: .infinity)
            .padding(.horizontal,2)
            .scrollContentBackground(.hidden)
            .listRowSpacing(10)

        }
    }
}

extension HomeView{

}

#Preview {
    HomeView(navigationPath: .constant([]))
}
