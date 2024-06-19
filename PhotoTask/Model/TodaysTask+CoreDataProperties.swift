//
//  TodaysTask+CoreDataProperties.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/19.
//
//

import Foundation
import CoreData


extension TodaysTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodaysTask> {
        return NSFetchRequest<TodaysTask>(entityName: "TodaysTask")
    }

    @NSManaged public var dailyID: UUID?
    @NSManaged public var dailyMemo: String?
    @NSManaged public var dailyPhoto: Data?
    @NSManaged public var updateDate: Date?

}

extension TodaysTask : Identifiable {

}
