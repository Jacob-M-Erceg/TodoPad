//
//  TaskFormModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-05.
//

import XCTest
@testable import TodoPad

class TaskFormModelTests: XCTestCase {
    
    
    // MARK: - Convience Variables
    var persistentTask = PersistentTask(title: "Workout", desc: nil, taskUUID: UUID(), dateCompleted: nil)
    
    var repeatingTask: RepeatingTask = RepeatingTask(
        title: "Push Day",
        desc: "A push day workout.",
        taskUUID: UUID(),
        isCompleted: false,
        startDate: Date(),
        time: Date().addingTimeInterval(60*60),
        repeatSettings: .daily,
        endDate: nil,
        notificationsEnabled: true
    )
    
    var nonRepeatingTask = NonRepeatingTask(
        title: "Finish coding app",
        desc: "Finish and submit app to apple.",
        taskUUID: UUID(),
        isCompleted: false,
        date: Date().addingTimeInterval(60*60*24*3),
        time: Date().addingTimeInterval(60*60*24*3),
        notificationsEnabled: false
    )
    
    
    // MARK: - Tests
    func testTaskFormModel_InitializeEmptyModel() {
        // Arrange
        let taskFormModel = TaskFormModel()
        
        // Assert
        XCTAssertNil(taskFormModel.title)
        XCTAssertNil(taskFormModel.description)
        
        XCTAssertNil(taskFormModel.startDate)
        XCTAssertNil(taskFormModel.time)
        XCTAssertNil(taskFormModel.repeatSettings)
        XCTAssertNil(taskFormModel.endDate)
        XCTAssertNotNil(taskFormModel.uuid)
        
        XCTAssertFalse(taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_InitializeWithPersistentTask() {
        // Arrange
        let taskFormModel = TaskFormModel(for: self.persistentTask)
        
        // Assert
        XCTAssertEqual(persistentTask.title, taskFormModel.title)
        XCTAssertEqual(persistentTask.desc, taskFormModel.description)
        XCTAssertEqual(persistentTask.taskUUID, taskFormModel.uuid)
        
        XCTAssertNil(taskFormModel.startDate)
        XCTAssertNil(taskFormModel.time)
        XCTAssertNil(taskFormModel.repeatSettings)
        XCTAssertNil(taskFormModel.endDate)
        XCTAssertFalse(taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_InitializeWithRepeatingTask() {
        // Arrange
        let taskFormModel = TaskFormModel(for: self.repeatingTask)
        
        // Assert
        XCTAssertEqual(repeatingTask.title, taskFormModel.title)
        XCTAssertEqual(repeatingTask.desc, taskFormModel.description)
        XCTAssertEqual(repeatingTask.startDate, taskFormModel.startDate)
        XCTAssertEqual(repeatingTask.time, taskFormModel.time)
        XCTAssertEqual(repeatingTask.repeatSettings.number, taskFormModel.repeatSettings?.number)
        XCTAssertEqual(repeatingTask.endDate, taskFormModel.endDate)
        XCTAssertEqual(repeatingTask.taskUUID, taskFormModel.uuid)
        XCTAssertEqual(repeatingTask.notificationsEnabled, taskFormModel.notificationsEnabled)
    }
    
    
    func testTaskFormModel_InitializeWithNonRepeatingTask() {
        // Arrange
        let taskFormModel = TaskFormModel(for: self.nonRepeatingTask)
        
        // Assert
        XCTAssertEqual(nonRepeatingTask.title, taskFormModel.title)
        XCTAssertEqual(nonRepeatingTask.desc, taskFormModel.description)
        XCTAssertEqual(nonRepeatingTask.date, taskFormModel.startDate)
        XCTAssertEqual(nonRepeatingTask.time, taskFormModel.time)
        
        XCTAssertNil(taskFormModel.repeatSettings)
        XCTAssertNil(taskFormModel.endDate)
        
        XCTAssertEqual(nonRepeatingTask.taskUUID, taskFormModel.uuid)
        XCTAssertEqual(nonRepeatingTask.notificationsEnabled, taskFormModel.notificationsEnabled)
    }
    
    
    func testTaskFormModel_WhenPersistentTaskFormModel_CurrentTaskFormModelTypeReturnsPersistent() {
        // Arrange
        let taskFormModel = TaskFormModel(for: self.persistentTask)
        
        // Assert
        XCTAssertEqual(taskFormModel.currentTaskFormModelType, TaskFormModel.TaskModelTypes.persistent)
    }
    
    func testTaskFormModel_WhenRepeatingTaskFormModel_CurrentTaskFormModelTypeReturnsRepeating() {
        // Arrange
        let taskFormModel = TaskFormModel(for: self.repeatingTask)
        
        // Assert
        XCTAssertEqual(taskFormModel.currentTaskFormModelType, TaskFormModel.TaskModelTypes.repeating)
    }
    
    func testTaskFormModel_WhenNonRepeatingTaskFormModel_CurrentTaskFormModelTypeReturnsNonRepeating() {
        // Arrange
        let taskFormModel = TaskFormModel(for: self.nonRepeatingTask)
        
        // Assert
        XCTAssertEqual(taskFormModel.currentTaskFormModelType, TaskFormModel.TaskModelTypes.nonRepeating)
    }
    
    
    // MARK: - Validate Form Model
    func testTaskFormModel_WhenNoTitleSet_isTitleValidReturnsFalse() {
        // Arrange
        let taskFormModel = TaskFormModel()
        
        // Assert
        XCTAssertFalse(taskFormModel.isTitleValid)
    }
    
    func testTaskFormModel_WhenTitleIsOver64Chars_isTitleValidReturnsFalse() {
        // Arrange
        var taskFormModel = TaskFormModel()
        taskFormModel.title = "This is a lot of words. I am typing a long, invalid title. We are now over 64 chars."
        
        // Assert
        XCTAssertFalse(taskFormModel.isTitleValid)
    }
    
    func testTaskFormModel_WhenTitleIsBetween2and64Chars_isTitleValidReturnsTrue() {
        // Arrange
        var taskFormModel = TaskFormModel()
        taskFormModel.title = "PushDayWorkout"
        
        // Assert
        XCTAssertTrue(taskFormModel.isTitleValid)
    }
    
    func testTaskFormModel_WhenDescriptionIsOver500Characters_isDescriptionValidReturnsFalse() {
        // Arrange
        var taskFormModel = TaskFormModel()
        var description = ""
        for x in 0...500 { description.append(x.description) }
        taskFormModel.description = description
        
        // Assert
        XCTAssertFalse(taskFormModel.isDescriptionValid)
    }
    
    func testTaskFormModel_WhenDescriptionIsUnder500Characters_isDescriptionValidReturnsTrue() {
        // Arrange
        var taskFormModel = TaskFormModel()
        taskFormModel.description = "A valid description."
        
        // Assert
        XCTAssertTrue(taskFormModel.isDescriptionValid)
    }
    
    func testTaskFormModel_WhenEndDateDoesNotExist_ReturnsTrue() {
        // Arrange
        let taskFormModel = TaskFormModel()
        
        // Assert
        XCTAssertTrue(taskFormModel.isEndDateValid)
    }
    
    func testTaskFormModel_WhenStartDateDoesNotExistButEndDateDoes_ReturnsFalse() {
        // Arrange
        var taskFormModel = TaskFormModel()
        taskFormModel.endDate = Date()
        
        // Assert
        XCTAssertFalse(taskFormModel.isEndDateValid)
    }
    
    func testTaskFormModel_WhenStartDateIsGreaterThanEndDate_ReturnsFalse() {
        // Arrange
        var taskFormModel = TaskFormModel()
        taskFormModel.startDate = Date().addingTimeInterval(60*60)
        taskFormModel.endDate = Date()
        
        // Assert
        XCTAssertFalse(taskFormModel.isEndDateValid)
    }
    
    func testTaskFormModel_WhenEndDateIsGreaterThanStartDate_ReturnsTrue() {
        // Arrange
        var taskFormModel = TaskFormModel()
        taskFormModel.startDate = Date()
        taskFormModel.endDate = Date().addingTimeInterval(60*60)
        
        // Assert
        XCTAssertTrue(taskFormModel.isEndDateValid)
    }
    
}
