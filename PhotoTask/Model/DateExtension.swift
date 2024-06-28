//
//  DateExtension.swift
//  PhotoTask
//
//  Created by 市東 on 2024/06/18.
//

import Foundation

extension Date{


    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }

    var endOfMonth : Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }

    var startOfPreviousMonth : Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }

    var numberOfDaysInMonth : Int {
        Calendar.current.component(.day, from: endOfMonth)
    }

    var sundayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let numberFromPreviousMonth = startOfMonthWeekday - 1
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }

    var calendarDisplayDays : [Date] {
        var days : [Date] = []

        for dayOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }

        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth)
            days.append(newDay!)
        }
        return days.filter{$0 >= sundayBeforeStart && $0 <= endOfMonth}.sorted(by: <)
    }

    var monthInt : Int {
        Calendar.current.component(.month, from: self)
    }

    var startOfDay : Date {
        Calendar.current.startOfDay(for: self)
    }

    var nextDay : Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var yesterday : Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    func toStringWithCurrentLocale() -> String {

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: self)
    }

    
}
