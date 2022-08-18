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
    
    /// Returns a time string
    /// - Format: 10:47 AM
    var timeString: String? {
        let df = DateFormatter()
        df.timeZone = .autoupdatingCurrent
        df.dateFormat = "h:mm a"
        return df.string(from: self)
    }
    
    /// Returns a date that can be compared to another date by time.
    /// This is done by changing the year, month and day to 2001-01-01.
    var comparableByTime: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .second, .timeZone], from: self)
        
        let blankDate = Date(timeIntervalSinceReferenceDate: 0) // Initiates date at 2001-01-01 00:00:00 +0000
        
        if let timeOnlyDate = calendar.date(byAdding: dateComponents, to: blankDate) {
            return timeOnlyDate
        } else {
            return nil
        }
    }
    
}
