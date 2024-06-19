//
//  PhotoTaskApp.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import SwiftUI
import CoreData

@main
struct PhotoTaskApp: App {
    let persistenceController = PersistentController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
        }
    }
}
