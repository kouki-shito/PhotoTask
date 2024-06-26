//
//  Tasks+CoreDataProperties.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/23.
//
//

import Foundation
import CoreData
import UIKit


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
    @NSManaged public var thumbnailPhoto: Data?
    @NSManaged public var isCongrated: Bool
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

// TODO: Need Refactaling Future

extension Tasks : Identifiable {

    public var todaysArray: [TodaysTask] {
        let set = todays as? Set<TodaysTask> ?? []
        return set.sorted {
            $0.updateDate! < $1.updateDate!
        }
    }
    public var leftDay : Int {getTaskDayLeft(day:NowORNext)}
    public var leftPages : Int64 {getPagesLeft(progress: progressPages)}
    public var progressPercent : Double {progressPercentage()}
    public var todayQuota : Int {getTodayQuota(leftDays: leftDay,leftPage: leftPages)}
    public var startToEnd : Int {startToEndDate()}

    private var NowORNext : Date {backNowORNextDate()}

    func progressPercentage() -> Double {

        return Double(progressPages) / Double(goalPages)
    }

    func getTodayQuota(leftDays : Int,leftPage : Int64 ) -> Int {

        if leftDays != 0{
            return Int(ceil(Double(leftPage) / Double(leftDays)))
        }else{
            return Int(leftPage)
        }
    }

    func backNowORNextDate() ->Date{

        for i in self.todaysArray{
            if i.todayProgress > 0 && i.updateDate == Date.now.startOfDay{
                return Date.now.startOfDay.nextDay
            }
        }
        return Date.now.startOfDay

    }

    func everydayQuotaArray(day : Date) -> String{

        var num : [Int] = []
        var prog : Int = Int(progressPages)


        if isRangeIn(day: day){
            if NowToEnd(day: NowORNext) != 0 && NowToEnd(day: day) >= 0{ // today != EndTask

                for i in 0..<(NowToEnd(day: NowORNext) + 1){

                    num.append(getTodayQuota(leftDays: leftDay  - i, leftPage: getPagesLeft(progress: Int64(prog))))
                    prog += getTodayQuota(leftDays: leftDay - i, leftPage: getPagesLeft(progress: Int64(prog)))

                }
            }else{ // today = EndTask
                num.append(todayQuota)
            }

            return String(num[num.count - NowToEnd(day: day) - 1])
        }else{
            return ""
        }

    }

    func getPagesLeft(progress : Int64) -> Int64 {
        if progress >= goalPages {
            return 0
        }
        return goalPages - progress
    }

    func getTaskDayLeft(day : Date) -> Int {

        let nowOfday = Calendar.current.startOfDay(for: day)
        let endOfday = Calendar.current.startOfDay(for: taskEndDate!)
        let daysLeft = Calendar.current.dateComponents([.day], from: nowOfday,to: endOfday)
        if daysLeft.day! < 0{
            return 0
        }else{
            return daysLeft.day! + 1
        }
    }

    func isRangeIn(day : Date) -> Bool{
        if (taskStartDate! <= day) && (day <= taskEndDate!) && NowORNext <= day.startOfDay{
            return true
        }else{
            return false
        }
    }

    func startToEndDate() -> Int{
        let endOfday = Calendar.current.startOfDay(for: taskEndDate!)
        let startOfday = Calendar.current.startOfDay(for: taskStartDate!)
        let daysLeft = Calendar.current.dateComponents([.day], from: startOfday,to: endOfday)
        return daysLeft.day!
    }

    func NowToEnd(day : Date) -> Int{

        let nowOfday = Calendar.current.startOfDay(for: day)
        let endOfday = Calendar.current.startOfDay(for: taskEndDate!)
        let daysLeft = Calendar.current.dateComponents([.day], from: nowOfday,to: endOfday)
        return daysLeft.day!

    }

    func addProgressPages(){

        for i in self.todaysArray{
            var prog = 0
            if i.todayProgress > 0{
                prog += Int(i.todayProgress)
            }
            progressPages = Int64(prog)
        }
    }

    func backPhotoData(day : Date) -> UIImage?{

        for i in self.todaysArray{

            if i.updateDate == day.startOfDay && i.dailyPhoto != nil{

                return UIImage(data: i.dailyPhoto!)

            }
        }
        return nil
    }

    func backTodays(day : Date) -> TodaysTask?{

        for i in self.todaysArray{

            if i.updateDate == day.startOfDay{

                return i
            }
        }

        return nil
    }

}
