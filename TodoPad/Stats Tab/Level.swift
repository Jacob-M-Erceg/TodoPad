//
//  Level.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-23.
//

import Foundation

enum Level {
    case level1(Int)
    case level2(Int)
    case level3(Int)
    case level4(Int)
    case level5(Int)
    case level6(Int)
    case error(Int)
}


// MARK: - Initalizers
extension Level {
    
    init(tasksCompleted: Int) {
        if tasksCompleted < 50 { self = .level1(tasksCompleted) }
        else if tasksCompleted < 250 { self = .level2(tasksCompleted) }
        else if tasksCompleted < 1000 { self = .level3(tasksCompleted) }
        else if tasksCompleted < 5000 { self = .level4(tasksCompleted) }
        else if tasksCompleted < 10000 { self = .level5(tasksCompleted) }
        else if tasksCompleted < 100000 { self = .level6(tasksCompleted) }
        else { self = .error(-404) }
    }
}


// MARK: - Computed Properties
extension Level {
    var tasksCompleted: Int {
        switch self {
        case .level1(let tasksCompleted),
                .level2(let tasksCompleted),
                .level3(let tasksCompleted),
                .level4(let tasksCompleted),
                .level5(let tasksCompleted),
                .level6(let tasksCompleted),
                .error(let tasksCompleted):
            return tasksCompleted
        }
    }
    
    var levelString: String {
        switch self {
        case .level1:
            return "Level 1"
        case .level2:
            return "Level 2"
        case .level3:
            return "Level 3"
        case .level4:
            return "Level 4"
        case .level5:
            return "Level 5"
        case .level6:
            return "Level 6"
        case .error:
            return "ERROR"
        }
    }
    
    var nextLevel: Int {
        switch self {
        case .level1: return 50
        case .level2: return 250
        case .level3: return 1000
        case .level4: return 5000
        case .level5: return 10000
        case .level6: return 100000
        case .error: return -404
        }
    }
    
}
