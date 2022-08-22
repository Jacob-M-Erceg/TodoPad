//
//  NonRepeatingTaskManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//

import Foundation
import CoreData

class NonRepeatingTaskManager {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    private func saveContext() {
        do {
            try self.context.save()
        } catch {
            assertionFailure("Error saving context \(error)")
        }
    }
}


// MARK: - Create
extension NonRepeatingTaskManager {
    
   @discardableResult
    public func saveNewNonRepeatingTask(with newTask: NonRepeatingTask) -> NonRepeatingTaskCD {
        let nonRepTask = NonRepeatingTaskCD(self.context, newTask)
        self.saveContext()
        return nonRepTask
    }
}


// MARK: - Read
extension NonRepeatingTaskManager {
    
    public func fetchNonRepeatingTasks(for date: Date) -> [NonRepeatingTask] {
        // Create Predicates
        let dateFrom = date.startOfDay
        guard let dateTo = date.endOfDay else { return [] }
        
        let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(NonRepeatingTaskCD.date))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(NonRepeatingTaskCD.date), dateTo as NSDate)
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        // Create fetch request
        let fetchRequest = NonRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = predicates
        
        // Fetch & unwrap CoreData models
        guard let nonRepeatingTasksCD = self.loadNonRepeatingTasks(with: fetchRequest) else { return [] }
        
        var tasks = [NonRepeatingTask]()
        
        for nonRepeatingTaskCD in nonRepeatingTasksCD {
            let nonRepeatingTask = NonRepeatingTask(nonRepeatingTaskCD: nonRepeatingTaskCD)
            tasks.append(nonRepeatingTask)
        }
        
        return tasks
    }
    
    /// Fetches a NonRepeatingTask for a given UUID, if it exists.
    public func fetchNonRepeatingTasks(for taskUUID: UUID) -> NonRepeatingTask? {
        let uuidPredicate = NSPredicate(format: "%@ == %K", taskUUID as NSUUID, #keyPath(NonRepeatingTaskCD.taskUUID))
        let fetchRequest = NonRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = uuidPredicate
        
        if let tasksCD = self.loadNonRepeatingTasks(with: fetchRequest),
           tasksCD.count == 1, let taskCD = tasksCD.first {
            return NonRepeatingTask.init(nonRepeatingTaskCD: taskCD)
        }
        
        return nil
    }

    
    public func fetchCompletedNonRepeatingTaskCount() -> Int {
        let fetchRequest = NonRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == true", #keyPath(NonRepeatingTaskCD.isCompleted))
        fetchRequest.resultType = .countResultType
        
        var count: Int = 0
        
        do {
            count = try context.count(for: fetchRequest)
        } catch {
            assertionFailure("PersistentTaskManager.fetchCompletedPersistentTaskCount Error \(error)")
        }
        
        return count
    }
}


// MARK: - Read
extension NonRepeatingTaskManager {
    
    public func updateNonRepeatingTask(with task: NonRepeatingTask) {
        let uuidPredicate = NSPredicate(format: "%@ == %K", task.taskUUID as NSUUID, #keyPath(NonRepeatingTaskCD.taskUUID))
        let fetchRequest = NonRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = uuidPredicate
        
        if let tasksCD = self.loadNonRepeatingTasks(with: fetchRequest), tasksCD.count == 1, let taskCD = tasksCD.first {
            taskCD.title = task.title
            taskCD.desc = task.desc
            taskCD.taskUUID = task.taskUUID
            taskCD.isCompleted = task.isCompleted
            taskCD.date = task.date
            taskCD.time = task.time
            taskCD.notificationsEnabled = task.notificationsEnabled
            self.saveContext()
        }
    }
    
    public func invertTaskCompleted(_ task: NonRepeatingTask) {
        let uuidPredicate = NSPredicate(format: "%@ == %K", task.taskUUID as NSUUID, #keyPath(NonRepeatingTaskCD.taskUUID))
        let fetchRequest = NonRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = uuidPredicate
        
        if let tasksCD = self.loadNonRepeatingTasks(with: fetchRequest), tasksCD.count == 1, let taskCD = tasksCD.first {
            taskCD.isCompleted = !taskCD.isCompleted // Todo maybe change this to task.isCompleted
            self.saveContext()
        }
    }
}


// MARK: - Delete
extension NonRepeatingTaskManager {
    
    public func deleteNonRepeatingTask(for task: NonRepeatingTask) {
        let uuidPredicate = NSPredicate(format: "%@ == %K", task.taskUUID as NSUUID, #keyPath(NonRepeatingTaskCD.taskUUID))
        let fetchRequest = NonRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = uuidPredicate
        
        if let tasksCD = self.loadNonRepeatingTasks(with: fetchRequest), tasksCD.count == 1, let taskCD = tasksCD.first {
            self.context.delete(taskCD)
            self.saveContext()
        }
    }
    
    public func deleteAllNonRepeatingTasks() {
        if let nonRepTasksCD = self.loadNonRepeatingTasks() {
            for nonRepTaskCD in nonRepTasksCD {
                self.context.delete(nonRepTaskCD)
            }
            self.saveContext()
        }
    }
}


// MARK: - Context Fetch Request
extension NonRepeatingTaskManager {
    
    private func loadNonRepeatingTasks(with request: NSFetchRequest<NonRepeatingTaskCD> = NonRepeatingTaskCD.fetchRequest()) -> [NonRepeatingTaskCD]? {
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching RepeatingTasks from context \(error)")
            return nil
        }
    }
}
