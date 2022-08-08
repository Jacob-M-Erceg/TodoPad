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
