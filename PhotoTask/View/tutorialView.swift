//
//  tutorialView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//

import SwiftUI

struct Tutorial{

    static let Imgtitle : [String] = ["problem","study","takeAphoto",
                               "bookBoy",]
    static let titleText : [String] = ["お困りですか？","計画を自動調整","成果を写真で記録","記録を振り返る"]
    static let description : [String] = ["PhotoTaskは期限とページ数から\n1日の勉強量を自動で計算します",
                                  "今日のページ数を登録すると\n明日以降のノルマが再計算されます",
                                  "ページ数を登録したら\n写真を撮って成果を証明しましょう",
                                  "過去の記録はカレンダーから\nいつでも振り返ることができます\n\nたくさんの写真で埋めてみましょう!"]
    
    static let imgAtoG : [String] = ["a","b1","b2","c","d1","d2","e1","e2","f1","f2","g1","g2"]
    static let descriptionAtoG : [String] = ["①+ボタンから新規タスク作成","②タスク名、期間、ページ数を入力\n「保存」を押してサムネイルを選択","③作成されたタスクは\n「進行中」「終了」\nの2つに自動分類されます","④詳細を見たいタスクをタップすると\nカレンダーで進捗確認ができます","⑤今日の日付をタップして\n一日の成果を登録しましょう","⑥入力が終わったら\n成果を写真で証明しよう","⑦過去の日付をタップすると\n一日の成果を振り返ることができます"]
}

struct tutorialView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
        VStack{
            Button(){
                dismiss()
            }label: {
                Image(systemName: "xmark")
                    .bold()
                    .contentShape(Circle())
                    .frame(maxWidth: .infinity,alignment: .topLeading)
                    .padding(.leading)
                    .padding(.top,5)
            }
            TabView{

                ForEach(0..<4){ index in

                    tutorialChildView(index: index)

                }
                TutorialA()
                TutorialB()
                TutorialC()
                TutorialD()
                TutorialE()
                TutorialF()
                TutorialG()

            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }


    }
}

#Preview {
    tutorialView()
}
