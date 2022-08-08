//
//  RepeatingTask.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation

struct RepeatingTask: TaskVariant {
    let title: String
    let desc: String?
    let taskUUID: UUID
    var isCompleted: Bool = false
    
    let startDate: Date
    let time: Date?
    let repeatSettings: RepeatSettings
    let endDate: Date?
    
    var notificationsEnabled: Bool
}

//extension RepeatingTask {
//    
//    init(repeatingTaskCD: RepeatingTaskCD) {
//        let repeatSettings = RepeatSettings.init(
//            with: repeatingTaskCD.repeatSettings.peroid,
//            days: repeatingTaskCD.repeatSettings.days
//        )
//        
//        self.title = repeatingTaskCD.title
//        self.desc = repeatingTaskCD.desc
//        self.taskUUID = repeatingTaskCD.taskUUID
//        self.isCompleted = false
//        
//        self.startDate = repeatingTaskCD.startDate
//        self.time = repeatingTaskCD.time
//        self.repeatSettings = repeatSettings
//        self.endDate = repeatingTaskCD.endDate
//        
//        self.notificationsEnabled = repeatingTaskCD.notificationsEnabled
//    }
//}
