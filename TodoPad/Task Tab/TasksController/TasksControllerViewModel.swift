//
//  TasksControllerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import Foundation

class TasksControllerViewModel {
    
    // MARK: - Callbacks
    var onUpdate: (() -> Void)?
    var onExpandCloseGroup: (([IndexPath], Bool) -> Void)?
    
    // MARK: - Managers/Services
    private(set) var persistentTaskManager: PersistentTaskManager
    private(set) var repeatingTaskManager: RepeatingTaskManager
    private(set) var nonRepeatingTaskManager: NonRepeatingTaskManager
    
    // MARK: - Variables
    private(set) var selectedDate: Date {
        didSet {
            self.fetchTasks(for: selectedDate)
        }
    }
    
    private(set) var taskGroups = [
        TaskGroup(title: "In Progress", isOpened: true, tasks: []),
        TaskGroup(title: "Completed", isOpened: true, tasks: []),
    ]
    
    init(
        persistentTaskManager: PersistentTaskManager = PersistentTaskManager(),
        repeatingTaskManager: RepeatingTaskManager = RepeatingTaskManager(),
        nonRepeatingTaskManager: NonRepeatingTaskManager = NonRepeatingTaskManager(),
        date: Date = Date()
    ) {
        self.persistentTaskManager = persistentTaskManager
        self.repeatingTaskManager = repeatingTaskManager
        self.nonRepeatingTaskManager = nonRepeatingTaskManager
        self.selectedDate = date
        
        self.fetchTasks(for: self.selectedDate)
    }
    
    public func changeSelectedDate(with date: Date) {
        self.selectedDate = date
    }
    
    public func openOrCloseTaskGroupSection(for taskGroup: TaskGroup) {
        
        for (section, viewModelTaskGroup) in self.taskGroups.enumerated() {
            if taskGroup.title == viewModelTaskGroup.title {
                self.taskGroups[section].isOpened = !self.taskGroups[section].isOpened
                var indexPaths: [IndexPath] = []
                
                for (row, _) in taskGroups[section].tasks.enumerated() {
                    indexPaths.append(IndexPath(row: row, section: section))
                }
                self.onExpandCloseGroup?(indexPaths, self.taskGroups[section].isOpened)
            }
        }
    }
}


// MARK: - Fetch & Refresh Tasks
extension TasksControllerViewModel {
    
    public func fetchTasks(for date: Date) {
        // Clear Tasks
        for (index, _) in self.taskGroups.enumerated() {
            self.taskGroups[index].tasks.removeAll()
        }
        
        // Get Tasks
        var tasks = [Task]()
        
        tasks.append(contentsOf: self.fetchRepeatingTasks(for: date))
        tasks.append(contentsOf: self.fetchPersistentTask(for: date))
        tasks.append(contentsOf: self.fetchNonRepeatingTask(for: date))

        
        // Sort Tasks by Time
        tasks.sort(by: { task1, task2 in
            if let task1Time = task1.time?.comparableByTime,
               let task2Time = task2.time?.comparableByTime {
                return task1Time < task2Time
            } else {
                return true
            }
        })
        
        // Sort Tasks into their Task Group
        for task in tasks {
            if task.isCompleted {
                // Completed Group
                self.taskGroups[1].tasks.append(task)
            } else {
                // In Progress Group
                self.taskGroups[0].tasks.append(task)
            }
        }
        
        self.onUpdate?()
    }
    
    /// Fetch Repeating Tasks
    public func fetchRepeatingTasks(for date: Date) -> [Task] {
        return self.repeatingTaskManager.fetchRepeatingTasks(on: date).map({ Task.repeating($0) })
    }
    
    /// Fetch Persistent Tasks
    public func fetchPersistentTask(for date: Date) -> [Task] {
        return persistentTaskManager.fetchPersistentTasks(filteredFor: self.selectedDate).map({ Task.persistent($0) })
    }
    
    /// Fetch Non-Repeating Tasks
    public func fetchNonRepeatingTask(for date: Date) -> [Task] {
        return nonRepeatingTaskManager.fetchNonRepeatingTasks(for: date).map({ Task.nonRepeating($0) })
    }
}


// MARK: - TaskCompleted Functions
extension TasksControllerViewModel {
    
    public func isTaskCompleted(with task: Task) -> Bool {
        let isCompleted: Bool

        switch task {
        case .persistent(let persistentTask):
            isCompleted = persistentTask.isCompleted

        case .repeating(let repeatingTask):
            isCompleted = self.repeatingTaskManager.isTaskMarkedCompleted(with: repeatingTask, for: self.selectedDate)

        case .nonRepeating(let nonRepeatingTask):
            isCompleted = nonRepeatingTask.isCompleted

        }

        return isCompleted
    }
    
    // MARK: - Update
    public func invertTaskCompleted(with task: Task) {
        
        switch task {
        case .persistent(let persistentTask):
            self.persistentTaskManager.invertTaskCompleted(persistentTask, for: self.selectedDate)
            
        case .repeating(let repeatingTask):
            let alreadyCompleted = self.repeatingTaskManager.isTaskMarkedCompleted(with: repeatingTask, for: selectedDate)
            
            // TODO - Do check and invert in one function
            if alreadyCompleted {
                self.repeatingTaskManager.setTaskNotCompleted(with: repeatingTask, for: selectedDate)
            } else {
                self.repeatingTaskManager.setTaskCompleted(with: repeatingTask, for: selectedDate)
            }
            
        case .nonRepeating(let nonRepeatingTask):
            self.nonRepeatingTaskManager.invertTaskCompleted(nonRepeatingTask)
        }
        
        self.fetchTasks(for: self.selectedDate)
    }
}


// MARK: - DeleteTask Functions
extension TasksControllerViewModel {
    
    public func deleteTask(for task: Task) {
        if task.notificationsEnabled {
            NotificationManager.removeNotifications(for: task)
        }
        
        switch task {
        case .persistent(let persistentTask):
            self.persistentTaskManager.deletePersistentTask(with: persistentTask)
            
        case .repeating(_):
            assertionFailure()
            break
            
        case .nonRepeating(let nonRepeatingTask):
            self.nonRepeatingTaskManager.deleteNonRepeatingTask(for: nonRepeatingTask)
        }
        
        self.fetchTasks(for: self.selectedDate)
    }
    
    public func deleteRepeatingTaskForThisAndFutureDays(for repeatingTask: RepeatingTask, selectedDate: Date) {
        // TODO - Make this only delete notifications for days after self.selectedDate
//        NotificationManager.removeNotifications(for: Task.repeating(repeatingTask))
        self.repeatingTaskManager.deleteThisAndFutureRepeatingTask(with: repeatingTask, deleteDate: selectedDate)
        self.fetchTasks(for: selectedDate)
    }
    
    public func completelyDeleteRepeatingTask(for repeatingTask: RepeatingTask) {
        if repeatingTask.notificationsEnabled {
            NotificationManager.removeNotifications(for: Task.repeating(repeatingTask))
        }
        self.repeatingTaskManager.completelyDeleteRepeatingTask(with: repeatingTask)
        self.fetchTasks(for: self.selectedDate)
    }
}
