//
//  RepeatingTaskStats.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-25.
//

import Foundation

struct RepeatingTaskStats {
    
    let repeatingTask: RepeatingTask
    let daysCompleted: Int
    
    // TODO - This shouldnt be days since started because yearly, monthly, weekly
    // It is actually times since started
    var daysSinceStarted: Int {
        let startDate = repeatingTask.startDate.startOfDay
        
        var endDate = Date()
        if let endDateTemp = repeatingTask.endDate, endDateTemp < endDate  { endDate = endDateTemp.addingTimeInterval(-60*60*24) }
        
        let repeatSettings = repeatingTask.repeatSettings
        
        switch repeatSettings {
        case .daily:
            return self.dailyDaysSinceStarted(startDate: startDate, endDate: endDate)
            
        case .weekly(let days):
            return self.weeklyDaysSinceStarted(startDate: startDate, endDate: endDate, days: days)
            
        case .monthly:
            return self.monthlyDaysSinceStarted(startDate: startDate, endDate: endDate)
            
        case .yearly:
            return self.yearlyDaysSinceStarted(startDate: startDate, endDate: endDate)
        }
    }
    
    private func dailyDaysSinceStarted(startDate: Date, endDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        guard let days = components.day.map({ $0 + 1}) else { return -404 }
        guard days > 0 else { return 0 }
        return days
    }
    
    private func weeklyDaysSinceStarted(startDate: Date, endDate: Date, days: [Int]) -> Int {
        var count = 0
        var curDate = startDate
        
        while curDate < endDate {
            let weekday = Calendar.current.dateComponents([.weekday], from: curDate).weekday
            if days.contains(where: { $0 == weekday }) {
                count += 1
            }
            curDate = curDate.addingTimeInterval(60*60*24)
        }
        return count
    }
    
    private func monthlyDaysSinceStarted(startDate: Date, endDate: Date) -> Int {
        var count = 0
        var increment: Int = 1
        var curDate = startDate
        
        while curDate < endDate {
            curDate = Calendar.current.date(byAdding: .month, value: increment, to: startDate)!
            increment += 1
            count += 1
        }
        return count
    }
    
    private func yearlyDaysSinceStarted(startDate: Date, endDate: Date) -> Int {
        var count = 0
        var increment: Int = 1
        var curDate = startDate
        
        while curDate <= endDate {
            devPrint(curDate)
            curDate = Calendar.current.date(byAdding: .year, value: increment, to: startDate)!
            increment += 1
            count += 1
        }
        return count
    }
}
