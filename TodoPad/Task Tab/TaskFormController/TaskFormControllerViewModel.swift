//
//  TaskFormControllerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-04.
//

import Foundation

class TaskFormControllerViewModel {
    
    enum TaskFormMode {
        case newTask
        case editTask
    }
    
    /// The date that was selected in TasksController before adding/editing a task.
    let selectedDate: Date
    private(set) var taskFormModel: TaskFormModel!
    /// For edit mode only
    private(set) var originalTask: Task?
    
    
//    private(set) var taskFormCellModels: [[TaskFormCellModel]] = [
//        [
//            TaskFormCellModel(cellType: .title),
//            TaskFormCellModel(cellType: .description)
//        ],
//        [
//            TaskFormCellModel(cellType: .startDate)
//        ]
//    ]
    
    init(_ selectedDate: Date, _ taskFormModel: TaskFormModel, _ originalTask: Task?) {
        self.selectedDate = selectedDate
        self.taskFormModel = taskFormModel
        self.originalTask = originalTask
    }
    
}

// MARK: - Computed Properties
extension TaskFormControllerViewModel {
    
    var taskFormMode: TaskFormMode {
        if self.originalTask == nil {
            return .newTask
        } else {
            return .editTask
        }
    }
    
    var navTitle: String {
        switch taskFormMode {
        case .newTask: return "New Task"
        case .editTask: return "Edit Task"
        }
    }
    
    var saveButtonTitle: String {
        switch taskFormMode {
        case .newTask: return "Add"
        case .editTask: return "Save"
        }
    }
}
