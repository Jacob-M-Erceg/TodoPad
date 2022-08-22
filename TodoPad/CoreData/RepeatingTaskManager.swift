//
//  RepeatingTaskManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//

import Foundation
import CoreData

class RepeatingTaskManager {
    
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
extension RepeatingTaskManager {
    
    /// Saves a new RepeatingTask to CoreData
    @discardableResult
    public func saveNewRepeatingTask(with newTask: RepeatingTask) -> RepeatingTaskCD {
        let repeatingTask = RepeatingTaskCD(self.context, newTask)
        self.saveContext()
        return repeatingTask
    }
}


// MARK: - Read
extension RepeatingTaskManager {
    
    public func fetchAllRepeatingTasks() -> [RepeatingTask] {
        guard let repeatingTasksCD = self.loadRepeatingTasks() else { return [] }
        
        var repeatingTasks: [RepeatingTask] = []
        
        for repeatingTaskCD in repeatingTasksCD {
            let repeatingTask = RepeatingTask(repeatingTaskCD: repeatingTaskCD)
            repeatingTasks.append(repeatingTask)
        }
        
        return repeatingTasks
    }
    
    /// Fetches RepeatingTask's starting from the given Date, if they exists.
    public func fetchRepeatingTasks(on date: Date) -> [RepeatingTask] {
        // Create Predicates
        let fromPredicate = NSPredicate(format: "%K <= %@", #keyPath(RepeatingTaskCD.startDate), date as NSDate)
        let toPredicate = NSPredicate(format: "%K > %@ OR %K == nil", #keyPath(RepeatingTaskCD.endDate), date as NSDate, #keyPath(RepeatingTaskCD.endDate))
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        // Create fetch request
        let fetchRequest = RepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = predicates
        
        // Fetch & unwrap CoreData models
        guard let repeatingTasks = self.loadRepeatingTasks(with: fetchRequest) else { return [] }
        
        // Convert CoreData models to normal models and return
        var tasks = [RepeatingTask]()
        
        for repeatingTask in repeatingTasks {
            let task = RepeatingTask(repeatingTaskCD: repeatingTask)
            tasks.append(task)
        }
        
        return tasks
    }
    
    /// Fetches the total task completed count for a RepeatingTask.
    /// Only returns Tasks up until the end of the current day.
    public func fetchRepeatingTaskCompletedCount(for repeatingTask: RepeatingTask) -> Int {
        let fetchRequest = CompletedRepeatingTaskCD.fetchRequest()
        fetchRequest.resultType = .countResultType
        
        let endDate: Date = Date().endOfDay ?? Date()
        let onlyTasksBeforePredicate = NSPredicate(format: "%K <= %@", #keyPath(CompletedRepeatingTaskCD.dateCompleted), endDate as NSDate)
        let uuidPredicate = NSPredicate(format: "%K == %@", #keyPath(CompletedRepeatingTaskCD.taskUUID), repeatingTask.taskUUID as NSUUID)
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [onlyTasksBeforePredicate, uuidPredicate])
        fetchRequest.predicate = predicates
        
        var count: Int = 0
        
        do {
            count = try context.count(for: fetchRequest)
        } catch {
            assertionFailure("PersistentTaskManager.fetchCompletedPersistentTaskCount Error \(error)")
        }
        return count
    }
    
    public func isTaskMarkedCompleted(with task: RepeatingTask, for date: Date) -> Bool {
        var isTaskMarkedCompleted = false
        
        if let _ = self.loadCompletedRepeatingTasks(with: task, for: date) {
            isTaskMarkedCompleted = true
        }
        return isTaskMarkedCompleted
    }
}


// MARK: - Update
extension RepeatingTaskManager {
    
    public func updateRepeatingTask(with task: RepeatingTask) {
        if let taskCD = self.loadRepeatingTask(for: task.taskUUID) {
            
            let repeatSettingsCD = taskCD.repeatSettings
            repeatSettingsCD.update(task.repeatSettings)
            
            taskCD.title = task.title
            taskCD.desc = task.desc
            taskCD.taskUUID = task.taskUUID
            
            taskCD.startDate = task.startDate
            taskCD.time = task.time
            taskCD.repeatSettings = repeatSettingsCD
            taskCD.endDate = task.endDate
            
            taskCD.notificationsEnabled = task.notificationsEnabled
            
            self.saveContext()
        }
    }
    
    public func setTaskCompleted(with task: RepeatingTask, for date: Date) {
        let completedTask = CompletedRepeatingTaskCD(context: context)
        completedTask.taskUUID = task.taskUUID
        completedTask.dateCompleted = date
        self.saveContext()
    }
    
    public func deleteCompletedRepeatingTask(with task: RepeatingTask, for date: Date) {
        if let completedTask = self.loadCompletedRepeatingTasks(with: task, for: date) {
            self.context.delete(completedTask)
            self.saveContext()
        }
    }
}


// MARK: - Destroy
extension RepeatingTaskManager {
    
    /// Sets the end date to the given 'deleteDate'.
    /// This will prevent the task from being shown in the given 'deleteDate' and future dates, but also keeps the task for previous dates.
    /// - Parameters:
    ///   - task: The RepeatingTask to delete
    ///   - deleteDate: The day the task is 'deleted' (hidden)
    public func deleteThisAndFutureRepeatingTask(with task: RepeatingTask, deleteDate: Date) {
        guard let task = self.loadRepeatingTask(for: task.taskUUID) else { return }
        task.endDate = deleteDate.startOfDay
        self.saveContext()
    }
    
    
    /// Hard deletes the RepeatingTask for all previous and future dates
    /// - Parameter task: The RepeatingTask to delete
    public func completelyDeleteRepeatingTask(with task: RepeatingTask) {
        guard let taskCD = self.loadRepeatingTask(for: task.taskUUID) else { return }
        self.context.delete(taskCD.repeatSettings)
        self.context.delete(taskCD)
        self.deleteAllCompletedTasks(for: task)
        self.saveContext()
    }
    
    private func deleteAllCompletedTasks(for task: RepeatingTask) {
        let fetchRequest = CompletedRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ == %K", task.taskUUID as NSUUID, #keyPath(CompletedRepeatingTaskCD.taskUUID))
        
        if let completedTasks = self.loadCompletedRepeatingTasks(with: fetchRequest) {
            for completedTask in completedTasks {
                self.context.delete(completedTask)
            }
        }
    }
    
    public func deleteAllRepeatingTasks() {
        if let repeatingTasksCD = self.loadRepeatingTasks() {
            for repeatingTaskCD in repeatingTasksCD {
                self.context.delete(repeatingTaskCD.repeatSettings)
                self.context.delete(repeatingTaskCD)
            }
        }
        
        if let completedTasksCD = self.loadCompletedRepeatingTasks() {
            for completedTaskCD in completedTasksCD {
                self.context.delete(completedTaskCD)
            }
        }
        
        self.saveContext()
    }
}


// MARK: - Context Fetch Requests
extension RepeatingTaskManager {
    
    /// Fetches a RepeatingTask for a given UUID, if it exists.
    private func loadRepeatingTask(for taskUUID: UUID) -> RepeatingTaskCD? {
        let uuidPredicate = NSPredicate(format: "%@ == %K", taskUUID as NSUUID, #keyPath(RepeatingTaskCD.taskUUID))
        let fetchRequest = RepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = uuidPredicate
        
        if let tasks = self.loadRepeatingTasks(with: fetchRequest),
           tasks.count == 1, let task = tasks.first {
            return task
        }
        
        return nil
    }
    
    private func loadRepeatingTasks(with request: NSFetchRequest<RepeatingTaskCD> = RepeatingTaskCD.fetchRequest()) -> [RepeatingTaskCD]? {
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching RepeatingTasks from context \(error)")
            return nil
        }
    }
    
    
    private func loadCompletedRepeatingTasks(with task: RepeatingTask, for date: Date) -> CompletedRepeatingTaskCD? {
        let dateFrom = date.startOfDay
        guard let dateTo = date.endOfDay else { return nil }
        
        let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(CompletedRepeatingTaskCD.dateCompleted))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(CompletedRepeatingTaskCD.dateCompleted), dateTo as NSDate)
        let uuidPredicate = NSPredicate(format: "%@ == %K", task.taskUUID as NSUUID, #keyPath(CompletedRepeatingTaskCD.taskUUID))
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, uuidPredicate])
        
        let fetchRequest = CompletedRepeatingTaskCD.fetchRequest()
        fetchRequest.predicate = predicates
        
        if let completedTask = self.loadCompletedRepeatingTasks(with: fetchRequest)?.first {
            return completedTask
        } else {
            return nil
        }
    }
    
    private func loadCompletedRepeatingTasks(with request: NSFetchRequest<CompletedRepeatingTaskCD> = CompletedRepeatingTaskCD.fetchRequest()) -> [CompletedRepeatingTaskCD]? {
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching RepeatingTasksCD from context \(error)")
            return nil
        }
    }
}
