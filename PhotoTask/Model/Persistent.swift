//
//  Persistent.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/16.
//

import Foundation
import CoreData


struct PersistentController {

    let container : NSPersistentContainer

    init(){

        container = NSPersistentContainer(name: "TaskData")
        container.loadPersistentStores(completionHandler: { (storeDescription , error) in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        })
    }
}
