//
//  RepeatingTaskCD+CoreDataClass.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//
//

import Foundation
import CoreData

@objc(RepeatingTaskCD)
public class RepeatingTaskCD: NSManagedObject {

    @discardableResult
    convenience init(_ context: NSManagedObjectContext, _ newTask: RepeatingTask) {
        self.init(context: context)
        
        self.title = newTask.title
        self.desc = newTask.desc
        self.startDate = newTask.startDate.startOfDay
        self.time = newTask.time
        self.endDate = newTask.endDate
        self.taskUUID = newTask.taskUUID

        self.notificationsEnabled = newTask.notificationsEnabled

        self.repeatSettings = RepeatSettingsCD(context, newTask.repeatSettings, self)
    }
}
