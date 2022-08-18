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
//    var onExpandCloseGroup: (([IndexPath], Bool) -> Void)?
    
    // MARK: - Managers/Services
    private let persistentTaskManager: PersistentTaskManager
    private let repeatingTaskManager: RepeatingTaskManager
    private let nonRepeatingTaskManager: NonRepeatingTaskManager
    
    // MARK: - Variables
    private(set) var selectedDate: Date
    
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
//        self.refreshTasks()
    }
    
    public func openOrCloseTaskGroupSection(for taskGroup: TaskGroup) {
        
//        for (section, viewModelTaskGroup) in self.taskGroups.enumerated() {
//            if taskGroup.title == viewModelTaskGroup.title {
//                self.taskGroups[section].isOpened = !self.taskGroups[section].isOpened
//                var indexPaths: [IndexPath] = []
//                
//                for (row, _) in taskGroups[section].tasks.enumerated() {
//                    indexPaths.append(IndexPath(row: row, section: section))
//                }
//                self.onExpandCloseGroup?(indexPaths, self.taskGroups[section].isOpened)
//            }
//        }
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
        // TODO -
        let tasks =  self.repeatingTaskManager.fetchRepeatingTasks(on: date).map({ Task.repeating($0) })
        return tasks.count < 0 ? tasks : RepeatingTask.getMockRepeatingTaskArray.map({ Task.repeating($0) })
    }
    
    /// Fetch Persistent Tasks
    public func fetchPersistentTask(for date: Date) -> [Task] {
        // TODO -
        let tasks =  persistentTaskManager.fetchPersistentTasks().map({ Task.persistent($0) })
        return tasks.count < 0 ? tasks : PersistentTask.getMockPersistentTaskArray.map({ Task.persistent($0) })
    }
    
    /// Fetch Non-Repeating Tasks
    public func fetchNonRepeatingTask(for date: Date) -> [Task] {
        // TODO -
        let tasks =   nonRepeatingTaskManager.fetchNonRepeatingTasks(for: date).map({ Task.nonRepeating($0) })
        return tasks.count < 0 ? tasks : NonRepeatingTask.getMockNonRepeatingTaskArray.map({ Task.nonRepeating($0) })
    }
    
}
