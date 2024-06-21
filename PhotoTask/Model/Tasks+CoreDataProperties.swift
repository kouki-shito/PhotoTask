//
//  Tasks+CoreDataProperties.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/21.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var goalPages: Int64
    @NSManaged public var progressPages: Int64
    @NSManaged public var taskEndDate: Date?
    @NSManaged public var taskName: String?
    @NSManaged public var tasksID: UUID?
    @NSManaged public var taskStartDate: Date?
    @NSManaged public var taskState: String?
    @NSManaged public var todays: NSSet?

}

// MARK: Generated accessors for todays
extension Tasks {

    @objc(addTodaysObject:)
    @NSManaged public func addToTodays(_ value: TodaysTask)

    @objc(removeTodaysObject:)
    @NSManaged public func removeFromTodays(_ value: TodaysTask)

    @objc(addTodays:)
    @NSManaged public func addToTodays(_ values: NSSet)

    @objc(removeTodays:)
    @NSManaged public func removeFromTodays(_ values: NSSet)

}

extension Tasks : Identifiable {

}
