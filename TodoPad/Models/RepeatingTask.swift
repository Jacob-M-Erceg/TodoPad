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

extension RepeatingTask {
    
    init(repeatingTaskCD: RepeatingTaskCD) {
        let repeatSettings = RepeatSettings.init(
            number: repeatingTaskCD.repeatSettings.peroid,
            days: repeatingTaskCD.repeatSettings.days
        )
        
        self.title = repeatingTaskCD.title
        self.desc = repeatingTaskCD.desc
        self.taskUUID = repeatingTaskCD.taskUUID
        self.isCompleted = false
        
        self.startDate = repeatingTaskCD.startDate
        self.time = repeatingTaskCD.time
        self.repeatSettings = repeatSettings
        self.endDate = repeatingTaskCD.endDate
        
        self.notificationsEnabled = repeatingTaskCD.notificationsEnabled
    }
}


extension RepeatingTask {
    
    static var getMockRepeatingTask: RepeatingTask {
        return RepeatingTask(
            title: "Eat brekfast",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(60*60*24*(-14)),
            time: Date().addingTimeInterval(60*60*2),
            repeatSettings: .daily,
            endDate: nil,
            notificationsEnabled: true
        )
    }
    
    static var getMockRepeatingTaskArray: [RepeatingTask] {
        var array = [RepeatingTask]()
        
        for x in 0...8 {
            let time: Date? = (x%2)==0 ? Date().addingTimeInterval(TimeInterval(60*60*x)) : nil
            
            array.append(
                RepeatingTask(
                    title: "Repeating task \(x)",
                    desc: "\(x)",
                    taskUUID: UUID(),
                    isCompleted: (x%2)==0,
                    startDate: Date().addingTimeInterval(60*60*24*(-14)),
                    time: time,
                    repeatSettings: .weekly([1, 2, 3]),
                    endDate: nil,
                    notificationsEnabled: true
                )
            )
        }
        return array
    }
}
