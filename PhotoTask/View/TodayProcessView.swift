//
//  TodayProcessView.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI

struct TodayProcessView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Binding var navigationPath : [Navigation]

    @FetchRequest(sortDescriptors: [])
    var tasks : FetchedResults<Tasks>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TodayProcessView(navigationPath: .constant([.calendar,.today]))
}