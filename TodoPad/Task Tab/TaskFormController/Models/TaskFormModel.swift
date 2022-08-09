//
//  TaskFormModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-04.
//

import Foundation

/// The model for a task that is new (un-saved) or being edited.
/// This is updated as a user fills out the title, description, etc and converted into a Task when it is saved.
struct TaskFormModel: Equatable {
    var title: String?
    var description: String?
    
    var startDate: Date?
    var time: Date?
    var repeatSettings: RepeatSettings?
    var endDate: Date?
    var uuid: UUID = UUID()
    
    var notificationsEnabled: Bool = false
    
    init() {}
    
    init(
        title: String? = nil,
        description: String? = nil,
        startDate: Date? = nil,
        time: Date? = nil,
        repeatSettings: RepeatSettings? = nil,
        endDate: Date? = nil,
        uuid: UUID = UUID(),
        notificationsEnabled: Bool = false
    ) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.time = time
        self.repeatSettings = repeatSettings
        self.endDate = endDate
        self.uuid = uuid
        self.notificationsEnabled = notificationsEnabled
    }
    
    init(for persistentTask: PersistentTask) {
        self.title = persistentTask.title
        self.description = persistentTask.desc
        self.startDate = nil
        self.time = nil
        self.repeatSettings = nil
        self.endDate = nil
        self.uuid = persistentTask.taskUUID
        self.notificationsEnabled = false
    }
    
    init(for repeatingTask: RepeatingTask) {
        self.title = repeatingTask.title
        self.description = repeatingTask.desc
        self.startDate = repeatingTask.startDate
        self.time = repeatingTask.time
        self.repeatSettings = repeatingTask.repeatSettings
        self.endDate = repeatingTask.endDate
        self.uuid = repeatingTask.taskUUID
        self.notificationsEnabled = repeatingTask.notificationsEnabled
    }
    
    init(for nonRepeatingTask: NonRepeatingTask) {
        self.title = nonRepeatingTask.title
        self.description = nonRepeatingTask.desc
        self.startDate = nonRepeatingTask.date
        self.time = nonRepeatingTask.time
        self.repeatSettings = nil
        self.endDate = nil
        self.uuid = nonRepeatingTask.taskUUID
        self.notificationsEnabled = nonRepeatingTask.notificationsEnabled
    }
}

extension TaskFormModel {
    
    enum TaskModelTypes {
        case repeating
        case nonRepeating
        case persistent
    }
    
    /// Returns either Repeating, Non-Repeating or Persistent Task based on the current variables of the model.
    var currentTaskFormModelType: TaskModelTypes {
        // RepeatSettings are always for Repeating Tasks
        if self.repeatSettings != nil {
            return .repeating
        }
        // StartDate but no repeating always means Non-Repeating
        else if self.startDate != nil && self.repeatSettings == nil {
            return .nonRepeating
        }
        // No StartDate always means Persistent
        else if self.startDate == nil {
            return .persistent
        }
        else { fatalError() }
    }
}

// MARK: - Validate Form Model
extension TaskFormModel {
    
    var isTitleValid: Bool {
        var returnValue = false
        
        if let title = self.title {
            if title.count > 1 && title.count < 64 {
                returnValue = true
            }
        }
        
        return returnValue
    }
    
    var isDescriptionValid: Bool {
        var returnValue = true
        
        if (self.description?.count ?? 0) > 500 {
            returnValue = false
        }
        
        return returnValue
    }
}

// MARK: - MOCKS (FOR DEVELOPMENT ONLY)
extension TaskFormModel {
    
    
    
    
}

