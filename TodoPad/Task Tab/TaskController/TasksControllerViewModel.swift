//
//  TasksControllerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import Foundation

class TasksControllerViewModel {
    
    // MARK: - Callbacks
//    var onUpdate: (() -> Void)?
    var onExpandCloseGroup: (([IndexPath], Bool) -> Void)?
    
    // MARK: - Variables
    private(set) var selectedDate: Date
    
    private(set) var taskGroups = [
        TaskGroup(title: "In Progress", isOpened: true, tasks: []),
        TaskGroup(title: "Completed", isOpened: true, tasks: []),
    ]
    
    init(
        date: Date = Date()
    ) {
        self.selectedDate = date
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
    
    private func fetchTasks(for date: Date) {
        for (index, _) in self.taskGroups.enumerated() {
            self.taskGroups[index].tasks.removeAll()
        }
        
//        self.fetchRepeatingTasks(for: date)
//        self.fetchPersistentTask(for: date)
//        self.fetchNonRepeatingTask(for: date)
        
//        self.onUpdate?()
    }
    
    
    
}
