//
//  NonRepeatingTaskCD+CoreDataClass.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//
//

import Foundation
import CoreData

@objc(NonRepeatingTaskCD)
public class NonRepeatingTaskCD: NSManagedObject {
    
  @discardableResult
  convenience init(_ context: NSManagedObjectContext, _ newTask: NonRepeatingTask) {
      self.init(context: context)
      
      self.title = newTask.title
      self.desc = newTask.desc
      self.taskUUID = newTask.taskUUID
      
      self.date = newTask.date
      self.time = newTask.time
      self.isCompleted = newTask.isCompleted
      
      self.notificationsEnabled = newTask.notificationsEnabled
  }
}
