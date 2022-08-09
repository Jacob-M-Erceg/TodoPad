//
//  TaskFormControllerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-04.
//

import XCTest
@testable import TodoPad

class TaskFormControllerViewModelTests: XCTestCase {
    
    var sutNewTask: TaskFormControllerViewModel!
    var sutEditTask: TaskFormControllerViewModel!
    
    // MARK: - Setup
    override func setUpWithError() throws {
        // SutNewTask
        self.sutNewTask = TaskFormControllerViewModel(Date(), TaskFormModel(), nil)
        
        // SutEditTask
        let repeatingTask = RepeatingTask(
            title: "Eat Broccoli",
            desc: "A description about eating broccoli.",
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().startOfDay,
            time: Date().addingTimeInterval(60*60*3),
            repeatSettings: RepeatSettings.daily,
            endDate: Date().addingTimeInterval(60*60*24*2),
            notificationsEnabled: true
        )
        let taskFormModel = TaskFormModel(for: repeatingTask)
        self.sutEditTask = TaskFormControllerViewModel(repeatingTask.startDate, taskFormModel, Task.repeating(repeatingTask))
    }
    
    override func tearDownWithError() throws {
        self.sutNewTask = nil
        self.sutEditTask = nil
    }
}


// MARK: - Initialize
extension TaskFormControllerViewModelTests {
    
    // MARK: - Initialize (New Task)
    func testTaskFormControllerViewModel_WhenInitializedAndNoOriginalTaskPassedIn_TaskFormModeIsNewTask() {
        XCTAssertEqual(self.sutNewTask.taskFormMode, TaskFormControllerViewModel.TaskFormMode.newTask)
    }
    
    func testTaskFormControllerViewModel_WhenInitializedForNewTask_InitializesWithCorrectTaskFormCellModelCells() {
        XCTAssertEqual(self.sutNewTask.taskFormCellModels.count, 2, "There should be two sections when initialized for new task.")
        
        if let section = self.sutNewTask.taskFormCellModels[optional: 0] {
            XCTAssertEqual(section.count, 2, "In the first section there should be two cells when initializing for a new task, a title and description.")
        } else {
            XCTFail()
        }
        
        if let section = self.sutNewTask.taskFormCellModels[optional: 1] {
            XCTAssertEqual(section.count, 1, "There should only be one cell in the second section when initializing for a new task, the start date cell.")
        } else {
            XCTFail()
        }
    }
    
    // MARK: - Initialize (Edit/Existing Task)
    func testTaskFormControllerViewModel_WheOriginalTaskPassedIn_TaskFormModeIsEditTask() {
        XCTAssertEqual(self.sutEditTask.taskFormMode, TaskFormControllerViewModel.TaskFormMode.editTask)
    }
}


// MARK: - TaskFormCellModels Enable/Disable Logic
extension TaskFormControllerViewModelTests {
    
//    func testTaskFormControllerViewModel_WhenStartCellEnabled() {
//        // Act
//        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
//
//        // Assert
//        XCTAssertNotNil(self.sutNewTask.taskFormModel.startDate)
//
//        XCTAssertEqual(self.sutNewTask.taskFormCellModels.count, 3, "There should be three sections when startDate is enabled.")
//
//        if let section = self.sutNewTask.taskFormCellModels[optional: 1] {
//            XCTAssertEqual(section.count, 3, "In the second section there should be three cells when startDate is enabled, the Date, Time and Repeating.")
//        } else { XCTFail() }
//
//        if let section = self.sutNewTask.taskFormCellModels[optional: 2] {
//            XCTAssertEqual(section.count, 1, "In the third section there should be only one cell when startDate is enabled, the Notification cell.")
//        } else { XCTFail() }
//    }
//
//    func testTaskFormControllerViewModel_WhenStartCellDisabled() {
//        // Act
//        self.sutEditTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: false)
//
//        // Assert
//        XCTAssertNil(self.sutEditTask.taskFormModel.startDate)
//        XCTAssertNil(self.sutEditTask.taskFormModel.time)
//        XCTAssertNil(self.sutEditTask.taskFormModel.repeatSettings)
//        XCTAssertNil(self.sutEditTask.taskFormModel.endDate)
//        XCTAssertFalse(self.sutEditTask.taskFormModel.notificationsEnabled)
//
//        XCTAssertEqual(self.sutEditTask.taskFormCellModels.count, 2, "There should be two sections when startDate is disabled.")
//
//        if let section = self.sutNewTask.taskFormCellModels[optional: 1] {
//            XCTAssertEqual(section.count, 1, "There should only be one cell (Date) in the second section when startDate is disabled.")
//        } else { XCTFail() }
//
//    }
//
//    func testTaskFormControllerViewModel_WhenRepeatSettingsEnabled() {
////        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
//        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .repeats), isEnabled: true)
//
//        XCTAssertNotNil(self.sutNewTask.taskFormModel.repeatSettings)
//
//        if let section = self.sutNewTask.taskFormCellModels[optional: 1] {
//            devPrint(section)
//            XCTAssertEqual(section.count, 4, "In the second section there should be four cells when repeatSettings is enabled, the Date, Time, Repeating and End Date.")
//        } else { XCTFail() }
//    }
    
//    func testTaskFormControllerViewModel_WhenRepeatSettingsDisabled() {
//
//    }
    
    func testTaskFormControllerViewModel_WhenStartCellEnabled_TaskFormModelStartDateNotNil() {
        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        XCTAssertNotNil(self.sutNewTask.taskFormModel.startDate)
    }
    
    func testTaskFormControllerViewModel_WhenStartCellDisabled_AllTaskFormCellVal() {
        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: false)
        XCTAssertNil(self.sutNewTask.taskFormModel.startDate)
    }
    
    func testTaskFormControllerViewModel_WhenTimeCellEnabled_TaskFormModelTimeNotNil() {
        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .time), isEnabled: true)
        XCTAssertNotNil(self.sutNewTask.taskFormModel.time)
    }

//    func testTaskFormControllerViewModel_WhenTimeCellEnabled_TaskFormModelTimeNotNil() {
//        self.sutNewTask.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
//        XCTAssertNotNil(self.sutNewTask.taskFormModel.startDate)
//    }
    
    
    
    
    
}


// MARK: - Update Task Form Model (Called from Delegate Functions in Cells)
extension TaskFormControllerViewModelTests {
    func testTaskFormControllerViewModel_UpdateTaskFormModelForTextField_UpdatesTitleInTaskFormModel() {
        // Arrange
        let originalTitle = self.sutNewTask.taskFormModel.title
        
        // Act
        self.sutNewTask.updateTaskFormModelForTextField(.init(cellType: .title), "My Title")
        
        // Assert
        XCTAssertNil(originalTitle)
        XCTAssertEqual(self.sutNewTask.taskFormModel.title, "My Title")
        XCTAssertNotEqual(originalTitle, self.sutNewTask.taskFormModel.title)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForTextFieldCalled_UpdatesDescriptionInTaskFormModel() {
        // Arrange
        let originalDescription = self.sutNewTask.taskFormModel.description
        
        // Act
        self.sutNewTask.updateTaskFormModelForTextField(.init(cellType: .description), "My Description")
        
        // Assert
        XCTAssertNil(originalDescription)
        XCTAssertEqual(self.sutNewTask.taskFormModel.description, "My Description")
        XCTAssertNotEqual(originalDescription, self.sutNewTask.taskFormModel.description)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForDateCalled_UpdatesStartDateInTaskFormModel() {
        // Arrange
        let originalStartDate = self.sutNewTask.taskFormModel.startDate
        let passedInDate = Date()
        
        // Act
        self.sutNewTask.updateTaskFormModelForDate(.init(cellType: .startDate), passedInDate)
        
        // Assert
        XCTAssertNil(originalStartDate)
        XCTAssertEqual(self.sutNewTask.taskFormModel.startDate, passedInDate)
        XCTAssertNotEqual(originalStartDate, self.sutNewTask.taskFormModel.startDate)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForDateCalled_UpdatesTimeInTaskFormModel() {
        // Arrange
        let originalTime = self.sutNewTask.taskFormModel.time
        let passedInTime = Date()
        
        // Act
        self.sutNewTask.updateTaskFormModelForDate(.init(cellType: .time), passedInTime)
        
        // Assert
        XCTAssertNil(originalTime)
        XCTAssertEqual(self.sutNewTask.taskFormModel.time, passedInTime)
        XCTAssertNotEqual(originalTime, self.sutNewTask.taskFormModel.time)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForDateCalled_UpdatesEndDateInTaskFormModel() {
        // Arrange
        let originalEndDate = self.sutNewTask.taskFormModel.endDate
        let passedInEndDate = Date()
        
        // Act
        self.sutNewTask.updateTaskFormModelForDate(.init(cellType: .endDate), passedInEndDate)
        
        // Assert
        XCTAssertNil(originalEndDate)
        XCTAssertEqual(self.sutNewTask.taskFormModel.endDate, passedInEndDate)
        XCTAssertNotEqual(originalEndDate, self.sutNewTask.taskFormModel.endDate)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForRepeatSettingsCalled_UpdatesRepeatSettingsInTaskFormModel() {
        // Arrange
        let originalRepeatSettings = self.sutNewTask.taskFormModel.repeatSettings
        let passedInRepeatSettings = RepeatSettings.weekly([1, 5])
        
        // Act
        self.sutNewTask.updateTaskFormModelForRepeatSettings(passedInRepeatSettings)
        
        // Assert
        XCTAssertNil(originalRepeatSettings)
        XCTAssertEqual(self.sutNewTask.taskFormModel.repeatSettings, passedInRepeatSettings)
        XCTAssertNotEqual(originalRepeatSettings, self.sutNewTask.taskFormModel.repeatSettings)
    }
}
