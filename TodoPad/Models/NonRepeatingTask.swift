//
//  NonRepeatingTask.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation

/// A task on a set date that does not repeat.
/// Different from a PersistentTask which has no date and persists until completed or deleted.
struct NonRepeatingTask: TaskVariant {
    let title: String
    let desc: String?
    let taskUUID: UUID
    var isCompleted: Bool = false
    
    let date: Date
    let time: Date?
    
    var notificationsEnabled: Bool
}

// MARK: - Initalizers
extension NonRepeatingTask {
    
    init(nonRepeatingTaskCD: NonRepeatingTaskCD) {
        self.title = nonRepeatingTaskCD.title
        self.desc = nonRepeatingTaskCD.desc
        self.taskUUID = nonRepeatingTaskCD.taskUUID
        self.isCompleted = nonRepeatingTaskCD.isCompleted
        
        self.date = nonRepeatingTaskCD.date
        self.time = nonRepeatingTaskCD.time
        
        self.notificationsEnabled = nonRepeatingTaskCD.notificationsEnabled
    }
}


extension NonRepeatingTask {
    
    static var getMockNonRepeatingTask: NonRepeatingTask {
        return NonRepeatingTask(
            title: "Hang out with Justin",
            desc: "At his house",
            taskUUID: UUID(),
            isCompleted: false,
            date: Date().addingTimeInterval(60*60*8),
            time: Date(),
            notificationsEnabled: true
        )
    }
    
    static var getMockNonRepeatingTaskArray: [NonRepeatingTask] {
        return [
            NonRepeatingTask(
                title: "Clean room",
                desc: nil,
                taskUUID: UUID(),
                isCompleted: true,
                date: Date(),
                time: Date().addingTimeInterval((-60)*60),
                notificationsEnabled: false
            ),
            NonRepeatingTask(
                title: "Hang out with Justin",
                desc: "At his house",
                taskUUID: UUID(),
                isCompleted: true,
                date: Date(),
                time: Date(), notificationsEnabled: true
            ),
            NonRepeatingTask(
                title: "Dentist appointment",
                desc: nil,
                taskUUID: UUID(),
                isCompleted: false,
                date: Date().addingTimeInterval(60*24),
                time: Date(),
                notificationsEnabled: false
            )
        ]
    }
}
