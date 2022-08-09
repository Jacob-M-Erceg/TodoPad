//
//  Date+Extensions.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-08.
//

import Foundation

extension Date {
    
    var startOfDay: Date {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let startOfDay = calendar.startOfDay(for: self)
        
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        return endOfDay
    }
    
}
