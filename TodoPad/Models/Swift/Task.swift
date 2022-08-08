//
//  Task.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation

@dynamicMemberLookup
enum Task {
    case persistent(PersistentTask)
    case repeating(RepeatingTask)
    case nonRepeating(NonRepeatingTask)
}


// MARK: - Subscript
extension Task {
    subscript<T>(dynamicMember keyPath: KeyPath<TaskVariant, T>) -> T {
        switch self {
        case .persistent(let persistantTask):
            return persistantTask[keyPath: keyPath]
            
        case .repeating(let repeatingTask):
            return repeatingTask[keyPath: keyPath]
            
        case .nonRepeating(let nonRepeatingTask):
            return nonRepeatingTask[keyPath: keyPath]
        }
    }
}
