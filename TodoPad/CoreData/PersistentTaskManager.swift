//
//  PersistentTaskManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-12.
//

import Foundation
import CoreData

class PersistentTaskManager {
    
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
extension PersistentTaskManager {
    
    @discardableResult
    public func saveNewPersistentTask(with newTask: PersistentTask) -> PersistentTaskCD {
        let pTaskCD = PersistentTaskCD(self.context, newTask)
        self.saveContext()
        return pTaskCD
    }
}


// MARK: - Read
extension PersistentTaskManager {
    
    
    /// Only fetches PersistentTask's that are Non-Completed, or PersistentTasks's that were completed on the given selectedDate
    /// - Parameter selectedDate: Completed PersistentTask's will only be returned for this date
    public func fetchPersistentTasks(filteredFor selectedDate: Date) -> [PersistentTask] {
        guard let pTasksCD = self.loadPersistentTasks() else { return [] }
        
        var pTasks: [PersistentTask] = []
        
        for pTaskCD in pTasksCD {
            let pTask = PersistentTask(persistentTaskCD: pTaskCD)
            
            if pTask.isCompleted && !DateHelper.isSameDay(pTask.dateCompleted!, selectedDate) {
                // Break out of this loop iteration & dont add to array because we only
                // show persistent tasks if they're non-completed or
                // completed on the current selected day
                continue
            }
            
            pTasks.append(pTask)
        }
        return pTasks
    }
    
    
    /// Fetches all PersistentTask's regardless of if they are completed, or non-completed
    /// - Returns: All PersistenTask's saved in core data
    public func fetchAllPersistentTasks() -> [PersistentTask] {
        guard let pTasksCD = self.loadPersistentTasks() else { return [] }
        
        var pTasks: [PersistentTask] = []
        
        for pTaskCD in pTasksCD {
            let pTask = PersistentTask(persistentTaskCD: pTaskCD)
            pTasks.append(pTask)
        }
        return pTasks
    }
    
    public func fetchCompletedPersistentTaskCount() -> Int {
        let fetchRequest = PersistentTaskCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K != nil", #keyPath(PersistentTaskCD.dateCompleted))
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


// MARK: - Update
extension PersistentTaskManager {
    
    public func updatePersistentTask(with task: PersistentTask) {
        if let taskCD = self.loadPersistentTask(for: task.taskUUID) {
            taskCD.title = task.title
            taskCD.desc = task.desc
            taskCD.dateCompleted = task.dateCompleted
            self.saveContext()
        }
    }
    
    public func invertTaskCompleted(_ task: PersistentTask, for date: Date) {
        if let taskCD = self.loadPersistentTask(for: task.taskUUID) {
            if taskCD.dateCompleted ==  nil {
                taskCD.dateCompleted = date
            } else {
                taskCD.dateCompleted = nil
            }
            self.saveContext()
        }
    }
}


// MARK: - Delete
extension PersistentTaskManager {
    
    public func deletePersistentTask(with task: PersistentTask) {
        if let taskCD = self.loadPersistentTask(for: task.taskUUID) {
            self.context.delete(taskCD)
            self.saveContext()
        }
    }
    
    public func deleteAllPersistentTasks() {
        if let tasksCD = self.loadPersistentTasks() {
            for tasksCD in tasksCD {
                self.context.delete(tasksCD)
            }
            self.saveContext()
        }
    }
}


// MARK: - Context Fetch Request
extension PersistentTaskManager {
    
    private func loadPersistentTask(for uuid: UUID) -> PersistentTaskCD? {
        let uuidPredicate = NSPredicate(format: "%@ == %K", uuid as NSUUID, #keyPath(PersistentTaskCD.taskUUID))
        let fetchRequest = PersistentTaskCD.fetchRequest()
        fetchRequest.predicate = uuidPredicate
        
        if let tasksCD = self.loadPersistentTasks(with: fetchRequest), tasksCD.count == 1, let taskCD = tasksCD.first {
            return taskCD
        } else {
            return nil
        }
    }
    
    private func loadPersistentTasks(with request: NSFetchRequest<PersistentTaskCD> = PersistentTaskCD.fetchRequest()) -> [PersistentTaskCD]? {
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching RepeatingTasks from context \(error)")
            return nil
        }
    }
}
