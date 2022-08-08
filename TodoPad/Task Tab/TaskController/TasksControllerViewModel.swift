//
//  TasksControllerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import Foundation

class TasksControllerViewModel {
    
    
    // MARK: - Variables
    private(set) var selectedDate: Date
    
    init(
        date: Date = Date()
    ) {
        self.selectedDate = date
    }
    
    public func changeSelectedDate(with date: Date) {
        self.selectedDate = date
//        self.refreshTasks()
    }
    
}
