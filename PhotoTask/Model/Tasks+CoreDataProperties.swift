//
//  Tasks+CoreDataProperties.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/19.
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

}

extension Tasks : Identifiable {

    public var leftDay : Int {getTaskDayLeft()}
    public var leftPages : Int64 {getPagesLeft()}
    public var progressPercent : Double {progressPercentage()}
    public var todayQuota : Int {getTodayQuota()}

    func progressPercentage() -> Double {

        return Double(progressPages) / Double(goalPages)
    }

    func getTodayQuota() -> Int {
        if leftDay != 0{
            return Int(ceil(Double(leftPages) / Double(leftDay)))
        }else{
            return Int(leftPages)
        }

    }

    func getPagesLeft() -> Int64 {
        if progressPages >= goalPages {
            return 0
        }
        return goalPages - progressPages
    }

    func getTaskDayLeft() -> Int {
        let nowOfday = Calendar.current.startOfDay(for: Date())
        let endOfday = Calendar.current.startOfDay(for: taskEndDate!)
        let daysLeft = Calendar.current.dateComponents([.day], from: nowOfday,to: endOfday)
        if daysLeft.day! < 0{
            return 0
        }else{
            return daysLeft.day! + 1
        }
    }
}
