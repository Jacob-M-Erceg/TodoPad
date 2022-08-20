//
//  Task.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation

protocol EnumTypeEquatable {
    static func ~=(lhs: Self, rhs: Self) -> Bool
}

@dynamicMemberLookup
enum Task {
    case persistent(PersistentTask)
    case repeating(RepeatingTask)
    case nonRepeating(NonRepeatingTask)
}

extension Task: EnumTypeEquatable {
    
    static func ~= (lhs: Task, rhs: Task) -> Bool {
        switch (lhs, rhs) {
        case (.persistent, .persistent),
            (.repeating, .repeating),
            (.nonRepeating, .nonRepeating):
            return true
        default:
            return false
        }
    }
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

// MARK: - Computed Property Getters
extension Task {
    
    var typeOfTask: String {
        switch self {
        case .persistent(_):
            return "Persistent"
        case .repeating(_):
            return "Repeating"
        case .nonRepeating(_):
            return "Non-Repeating"
        }
    }
    
    /// For quickly getting the associated value without using a switch statement
    /// - Returns: Returns PersistentTask if enum is .persistant
    var getPersistentTask: PersistentTask? {
        if case let .persistent(persistant) = self {
            return persistant
        }
        return nil
    }
    
    /// For quickly getting the associated value without using a switch statement
    /// - Returns: Returns RepeatingTask if enum is .repeating
    var getRepeatingTask: RepeatingTask? {
        if case let .repeating(repeating) = self {
            return repeating
        }
        return nil
    }
    
    /// For quickly getting the associated value without using a switch statement
    /// - Returns: Returns NonRepeatingTask if enum is .nonRepeating
    var getNonRepeatingTask: NonRepeatingTask? {
        if case let .nonRepeating(nonRepeating) = self {
            return nonRepeating
        }
        return nil
    }
}
