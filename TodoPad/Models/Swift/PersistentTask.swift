//
//  PersistentTask.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation


/// A task that persists until completed.
struct PersistentTask: TaskVariant {
    let title: String
    let desc: String?
    let taskUUID: UUID
    
    var isCompleted: Bool {
        var isCompleted = false
        if dateCompleted != nil { isCompleted = true }
        return isCompleted
    }
    
    let dateCompleted: Date?
    
    // Always false
    let notificationsEnabled: Bool = false
}

// MARK: - Initalizers
//extension PersistentTask {
//    
//    init(persistentTaskCD: PersistentTaskCD) {
//        self.title = persistentTaskCD.title
//        self.desc = persistentTaskCD.desc
//        self.taskUUID = persistentTaskCD.taskUUID
//        self.dateCompleted = persistentTaskCD.dateCompleted
//    }
//}


extension PersistentTask {
    
    static var getMockPersistentTask: PersistentTask {
        return PersistentTask(title: "Finish Math Homework", desc: "Assignment 2", taskUUID: UUID(), dateCompleted: nil)
    }
    
    static var getMockPersistentTaskArray: [PersistentTask] {
        return [
            PersistentTask(title: "Finish Math Homework", desc: "Assignment 2", taskUUID: UUID(), dateCompleted: nil),
            PersistentTask(title: "Take out trash", desc: nil, taskUUID: UUID(), dateCompleted: nil),
            PersistentTask(title: "Do the dishes", desc: nil, taskUUID: UUID(), dateCompleted: nil),
            PersistentTask(title: "Test core data", desc: nil, taskUUID: UUID(), dateCompleted: nil),
            PersistentTask(title: "Visit grandma", desc: nil, taskUUID: UUID(), dateCompleted: nil),
            PersistentTask(title: "Visit grandma", desc: nil, taskUUID: UUID(), dateCompleted: nil),
            PersistentTask(title: "Finish app", desc: nil, taskUUID: UUID(), dateCompleted: nil),
        ]
    }
}
