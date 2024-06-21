//
//  TodaysTask+CoreDataProperties.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/21.
//
//

import Foundation
import CoreData


extension TodaysTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodaysTask> {
        return NSFetchRequest<TodaysTask>(entityName: "TodaysTask")
    }

    @NSManaged public var dailyMemo: String?
    @NSManaged public var dailyPhoto: Data?
    @NSManaged public var updateDate: Date?
    @NSManaged public var todayProgress: Int64
    @NSManaged public var task: Tasks?

}

extension TodaysTask : Identifiable {

}
