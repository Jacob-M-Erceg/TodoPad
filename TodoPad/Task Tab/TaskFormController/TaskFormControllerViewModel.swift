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
    
    // MARK: - Callbacks
    var onUpdate: (()->Void)?
    
    // MARK: - Managers/Services
    private(set) var persistentTaskManager: PersistentTaskManager
    private(set) var repeatingTaskManager: RepeatingTaskManager
    private(set) var nonRepeatingTaskManager: NonRepeatingTaskManager
    
    // MARK: - Variables
    let selectedDate: Date
    private(set) var taskFormModel: TaskFormModel!
    /// For edit mode only
    private(set) var originalTask: Task?
    
    private(set) var taskFormCellModels: [[TaskFormCellModel]] = [
        [
            TaskFormCellModel(cellType: .title),
            TaskFormCellModel(cellType: .description)
        ],
        [
            TaskFormCellModel(cellType: .startDate)
        ]
    ]
    
    // MARK: - Init
    init(
        selectedDate: Date,
        taskFormModel: TaskFormModel,
        originalTask: Task?,
        persistentTaskManager: PersistentTaskManager = PersistentTaskManager(),
        repeatingTaskManager: RepeatingTaskManager = RepeatingTaskManager(),
        nonRepeatingTaskManager: NonRepeatingTaskManager = NonRepeatingTaskManager()
    ) {
        self.selectedDate = selectedDate
        self.taskFormModel = taskFormModel
        self.originalTask = originalTask
        
        self.persistentTaskManager = persistentTaskManager
        self.repeatingTaskManager = repeatingTaskManager
        self.nonRepeatingTaskManager = nonRepeatingTaskManager
        
        if self.taskFormMode == .editTask {
            self.updateFormCellModels()
        }
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


// MARK: - Is Enabled Logic
extension TaskFormControllerViewModel {
    
    public func didChangeCellIsEnabled(_ taskFormCellModel: TaskFormCellModel, isEnabled: Bool) {
        self.closeAllExpandedCells()
        self.updateFormModelWhenCellEnableChange(taskFormCellModel, isEnabled)
        self.updateFormCellModels()
        self.expandCellWhenIsEnabledChanged(taskFormCellModel, isEnabled)
        self.onUpdate?()
    }
    
    private func updateFormModelWhenCellEnableChange(_ taskFormCellModel: TaskFormCellModel, _ isEnabled: Bool) {
        if isEnabled {
            switch taskFormCellModel.cellType {
            case .title, .description:
                break
            case .startDate:
                self.taskFormModel.startDate = self.selectedDate
            case .time:
                self.taskFormModel.time = self.selectedDate
            case .repeats:
                self.taskFormModel.repeatSettings = .daily
            case .endDate:
                self.taskFormModel.endDate = self.selectedDate.endOfDay
            case .notifications:
                self.taskFormModel.notificationsEnabled = true
            }
        }
        else if !isEnabled {
            switch taskFormCellModel.cellType {
            case .title, .description:
                break
                
            case .startDate:
                self.taskFormModel.startDate = nil
                self.taskFormModel.time = nil
                self.taskFormModel.repeatSettings = nil
                self.taskFormModel.endDate = nil
                self.taskFormModel.notificationsEnabled = false
                
            case .time:
                self.taskFormModel.time = nil
                
            case .repeats:
                self.taskFormModel.repeatSettings = nil
                self.taskFormModel.endDate = nil
                
            case .endDate:
                self.taskFormModel.endDate = nil
                
            case .notifications:
                self.taskFormModel.notificationsEnabled = false
            }
        }
    }
    
    // MARK: - updateFormCellModels Functions
    func updateFormCellModels() {
        self.removeAllOptionalTaskFormCells()
        self.setupConditionalCellsForStartDate()
        self.setupConditionalCellsForRepeatSettings()
        self.updateIsEnabledCells()
    }
    
    private func removeAllOptionalTaskFormCells() {
        self.taskFormCellModels[1].removeAll(where: { $0.cellType != .startDate })
        // Remove notification cell
        if self.taskFormCellModels.count == 3 {
            self.taskFormCellModels.remove(at: 2)
        }
    }
    
    private func setupConditionalCellsForStartDate() {
        if self.taskFormModel.startDate != nil {
            if let _ = self.taskFormCellModels[1].firstIndex(where: { $0.cellType == .startDate }) {
                self.taskFormCellModels[1].append(TaskFormCellModel(cellType: .time))
                self.taskFormCellModels[1].append(TaskFormCellModel(cellType: .repeats))
                self.taskFormCellModels.append([TaskFormCellModel(cellType: .notifications)])
            }
        }
    }
    
    private func setupConditionalCellsForRepeatSettings() {
        if self.taskFormModel.repeatSettings != nil {
            if let _ = self.taskFormCellModels[1].firstIndex(where: { $0.cellType == .repeats }) {
                self.taskFormCellModels[1].append(TaskFormCellModel(cellType: .endDate))
            }
        }
    }
    
    
    private func updateIsEnabledCells() {
        // StartDate
        if self.taskFormModel.startDate != nil {
            if let index = self.taskFormCellModels[1].firstIndex(where: { $0.cellType == .startDate }) {
                self.taskFormCellModels[1][index].setIsEnabled(isEnabled: true)
            }
        } else {
            if let index = self.taskFormCellModels[1].firstIndex(where: { $0.cellType == .startDate }) {
                self.taskFormCellModels[1][index].setIsEnabled(isEnabled: false)
            }
        }
        
        // Time
        if self.taskFormModel.time != nil {
            if let index = self.taskFormCellModels[1].firstIndex(where: { $0.cellType == .time }) {
                self.taskFormCellModels[1][index].setIsEnabled(isEnabled: true)
            }
        }
        
        // Repeat Settings
        if self.taskFormModel.repeatSettings != nil {
            if let index = self.taskFormCellModels[1].firstIndex(where: { $0.cellType == .repeats }) {
                self.taskFormCellModels[1][index].setIsEnabled(isEnabled: true)
            }
        }
        
        // End Date
        if self.taskFormModel.endDate != nil {
            if let index = self.taskFormCellModels[1].firstIndex(where: { $0.cellType == .endDate }) {
                self.taskFormCellModels[1][index].setIsEnabled(isEnabled: true)
            }
        }
        
        // Notifications
        if self.taskFormModel.notificationsEnabled == true {
            if self.taskFormCellModels.count == 3,
               let index = self.taskFormCellModels[2].firstIndex(where: { $0.cellType == .notifications }) {
                self.taskFormCellModels[2][index].setIsEnabled(isEnabled: true)
            }
        }
    }
    
}


// MARK: - Is Expanded Logic
extension TaskFormControllerViewModel {
    
    // TODO - IsExpanded Tests
    
    public func invertIsExpanded(_ indexPath: IndexPath) {
        let taskCell = self.taskFormCellModels[indexPath.section][indexPath.row]
        let taskCellState = taskCell.isExpanded
        self.closeAllExpandedCells()
        self.taskFormCellModels[indexPath.section][indexPath.row].setIsExpanded(isExpanded: !taskCellState)
        self.onUpdate?()
    }
    
    private func closeAllExpandedCells() {
        for (section, array) in self.taskFormCellModels.enumerated() {
            for (index, _) in array.enumerated() {
                if self.taskFormCellModels[section][index].isExpanded {
                    self.taskFormCellModels[section][index].setIsExpanded(isExpanded: false)
                }
            }
        }
    }
    
    private func expandCellWhenIsEnabledChanged(_ taskFormCellModel: TaskFormCellModel, _ isEnabled: Bool) {
        for (section, array) in self.taskFormCellModels.enumerated() {
            for (index, taskCell) in array.enumerated() {
                if taskCell.cellType == taskFormCellModel.cellType {
                    self.taskFormCellModels[section][index].setIsExpanded(isExpanded: isEnabled)
                }
            }
        }
    }
}


// MARK: - Update Task Form Model
extension TaskFormControllerViewModel {
    
    public func updateTaskFormModelForTextField(_ taskFormCellModel: TaskFormCellModel, _ string: String?) {
        guard let string = string else { return }
        
        switch taskFormCellModel.cellType {
        case .title:
            self.taskFormModel.title = string
            
        case .description:
            self.taskFormModel.description = string
            
        case .startDate, .time, .repeats, .endDate, .notifications:
            assertionFailure("TaskFormControllerViewModel.updateTaskFormModelForTextField Error")
            return
        }
    }
    
    public func updateTaskFormModelForDate(_ taskFormCellModel: TaskFormCellModel, _ date: Date?) {
        switch taskFormCellModel.cellType {
        case .startDate:
            self.taskFormModel.startDate = date
            
        case .time:
            self.taskFormModel.time = date
            
        case .endDate:
            self.taskFormModel.endDate = date
            
        case .notifications, .repeats, .description, .title:
            assertionFailure("TaskFormControllerViewModel.updateTaskFormModelForDate Error")
            return
        }
    }
    
    public func updateTaskFormModelForRepeatSettings(_ repeatSettings: RepeatSettings?) {
        self.taskFormModel.repeatSettings = repeatSettings
    }
}


// MARK: - Validate Task Form Model
extension TaskFormControllerViewModel {
    
    public func validateTaskFormModel(with taskFormModel: TaskFormModel) -> Task? {
        guard taskFormModel.isTitleValid, taskFormModel.isDescriptionValid, taskFormModel.isEndDateValid
        else { return nil }
        
        switch self.taskFormModel.currentTaskFormModelType {
            
        case .repeating:
            let repeatingTask = self.createRepeatingTask(with: taskFormModel)
            return Task.repeating(repeatingTask)
            
        case .nonRepeating:
            let nonRepeatingTask = self.createNonRepeatingTask(with: taskFormModel)
            return Task.nonRepeating(nonRepeatingTask)
            
        case .persistent:
            let persistentTask = self.createPersistentTask(with: taskFormModel)
            return Task.persistent(persistentTask)
        }
    }
    
    private func createRepeatingTask(with taskFormModel: TaskFormModel) -> RepeatingTask {
        
        var time: Date?
        if self.taskFormCellModels[1].contains(where: { $0.cellType == .time && $0.isEnabled }) {
            time = taskFormModel.time
        }
        
        var endDate: Date?
        if self.taskFormCellModels[1].contains(where: { $0.cellType == .endDate && $0.isEnabled }) {
            endDate = taskFormModel.endDate
        }
        
        return RepeatingTask(
            title: taskFormModel.title!,
            desc: taskFormModel.description,
            taskUUID: taskFormModel.uuid,
            isCompleted: false,
            startDate: taskFormModel.startDate ?? self.selectedDate,
            time: time,
            repeatSettings: taskFormModel.repeatSettings ?? .daily,
            endDate: endDate,
            notificationsEnabled: taskFormModel.notificationsEnabled
        )
    }
    
    private func createNonRepeatingTask(with taskFormModel: TaskFormModel) -> NonRepeatingTask {
        
        var time: Date?
        if self.taskFormCellModels[1].contains(where: { $0.cellType == .time && $0.isEnabled }) {
            time = taskFormModel.time
        }
        
        return NonRepeatingTask(
            title: taskFormModel.title!,
            desc: taskFormModel.description,
            taskUUID: taskFormModel.uuid,
            isCompleted: false,
            date: taskFormModel.startDate ?? self.selectedDate,
            time: time,
            notificationsEnabled: taskFormModel.notificationsEnabled
        )
    }
    
    private func createPersistentTask(with taskFormModel: TaskFormModel) -> PersistentTask {
        return PersistentTask(
            title: taskFormModel.title!,
            desc: taskFormModel.description,
            taskUUID: taskFormModel.uuid,
            dateCompleted: nil
        )
    }
}


// MARK: - Save/Update Task
extension TaskFormControllerViewModel {
    
    func saveNewTask(task: Task) {
        switch task {
        case .persistent(let persistentTask):
            self.persistentTaskManager.saveNewPersistentTask(with: persistentTask)
            
        case .repeating(let repeatingTask):
            self.repeatingTaskManager.saveNewRepeatingTask(with: repeatingTask)
            
        case .nonRepeating(let nonRepeatingTask):
            self.nonRepeatingTaskManager.saveNewNonRepeatingTask(with: nonRepeatingTask)
        }
    }
    
    func editExistingTask(task: Task) {
        switch task {
        case .persistent(let persistentTask):
            self.persistentTaskManager.updatePersistentTask(with: persistentTask)
            
        case .repeating(let repeatingTask):
            self.repeatingTaskManager.updateRepeatingTask(with: repeatingTask)
            
        case .nonRepeating(let nonRepeatingTask):
            self.nonRepeatingTaskManager.updateNonRepeatingTask(with: nonRepeatingTask)
        }
    }
}
