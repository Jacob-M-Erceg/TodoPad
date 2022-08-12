//
//  PersistentTaskCD+CoreDataClass.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-12.
//
//

import Foundation
import CoreData

@objc(PersistentTaskCD)
public class PersistentTaskCD: NSManagedObject {

    @discardableResult
    convenience init(_ context: NSManagedObjectContext, _ newTask: PersistentTask) {
        self.init(context: context)
        
        self.title = newTask.title
        self.desc = newTask.desc
        self.taskUUID = newTask.taskUUID
        self.dateCompleted = newTask.dateCompleted
    }
}
