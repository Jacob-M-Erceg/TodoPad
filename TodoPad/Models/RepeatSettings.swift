//
//  RepeatSettings.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation

/// Repeat settings for RepeatingTask's. Eg: Daily, Weekly, Monthly, etc.
/// - weekly [Int]: Sun = 1, Mon = 2, Tues = 3, etc.
enum RepeatSettings: Equatable {
    case daily
    case weekly([Int])
    case monthly
    case yearly
    
    init(number: Int) {
        if number == 0 { self = .daily }
        else if number == 1 { self = .weekly([]) }
        else if number == 2 { self = .monthly }
        else if number == 3 { self = .yearly }
        else { fatalError("RepeatSettings init error.") }
    }
    
    init(number: Int16, days: [NSInteger]) {
        if number == 0 { self = .daily }
        else if number == 1 { self = .weekly(days) }
        else if number == 2 { self = .monthly }
        else if number == 3 { self = .yearly }
        else { fatalError("RepeatSettings init error.") }
    }
    
    var number: Int {
        switch self {
            case .daily: return 0
            case .weekly(_): return 1
            case .monthly:  return 2
            case .yearly: return 3
        }
    }
    
    var repeatPeroidString: String {
        switch self {
        case .daily:
            return "Repeats Daily"
        case .weekly:
            return "Repeats Weekly"
        case .monthly:
            return "Repeats Monthly"
        case .yearly:
            return "Repeats Yearly"
        }
    }
    
    var getWeeklyArray: [Int]? {
        switch self {
        case .weekly(let array):
            return array

        case .daily, .monthly, .yearly:
            return nil
        }
    }
}
