//
//  TaskFormControllerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-04.
//

import XCTest
@testable import TodoPad

class TaskFormControllerViewModelTests: XCTestCase {
    
    var sut: TaskFormControllerViewModel!
    
    // MARK: - Setup
    override func setUpWithError() throws {
        self.sut = TaskFormControllerViewModel(Date(), TaskFormModel(), nil)
    }
    
    private func setupSut(using taskFormModel: TaskFormModel) {
        self.sut = TaskFormControllerViewModel(Date(), taskFormModel, nil)
    }
    
    private func setupSutInEditMode(task: Task) {
        switch task {
        case .persistent(let pTask):
            let taskFormModel = TaskFormModel(for: pTask)
            self.sut = TaskFormControllerViewModel(Date(), taskFormModel, task)
            
        case .repeating(let rTask):
            let taskFormModel = TaskFormModel(for: rTask)
            self.sut = TaskFormControllerViewModel(rTask.startDate, taskFormModel, task)
            
        case .nonRepeating(let nonRepTask):
            let taskFormModel = TaskFormModel(for: nonRepTask)
            self.sut = TaskFormControllerViewModel(nonRepTask.date, taskFormModel, task)
        }
    }
    
    private func setupSutWithAllCellsEnabled() {
        let rTask = RepeatingTask(
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
        self.setupSutInEditMode(task: Task.repeating(rTask))
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
    }
}


// MARK: - Initialize
extension TaskFormControllerViewModelTests {
    
    // MARK: - Initialize (New Task)
    func testTaskFormControllerViewModel_WhenInitializedAndNoOriginalTaskPassedIn_TaskFormModeIsNewTask() {
        XCTAssertEqual(self.sut.taskFormMode, TaskFormControllerViewModel.TaskFormMode.newTask)
    }
    
    // MARK: - Initialize (Edit/Existing Task)
    func testTaskFormControllerViewModel_WheOriginalTaskPassedIn_TaskFormModeIsEditTask() {
        self.setupSutInEditMode(task: Task.repeating(RepeatingTask.getMockRepeatingTask))
        XCTAssertEqual(self.sut.taskFormMode, TaskFormControllerViewModel.TaskFormMode.editTask)
    }
}


// MARK: - TaskFormCellModels Enable/Disable Logic
extension TaskFormControllerViewModelTests {
    
    // MARK: - Task Form Model Variables
    // NOTE: Title & Description cannot be disabled so their variables are not affected here
    
    func testTaskFormModel_WhenStartDateSetEnabled_OnlyNotNilIsStartDate() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        
        // Assert
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        
        XCTAssertNil(self.sut.taskFormModel.time)
        XCTAssertNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNil(self.sut.taskFormModel.endDate)
        XCTAssertFalse(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenStartDateSetDisabled_AllVariablesNil() {
        // Arrange & Act
        self.setupSutWithAllCellsEnabled()
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: false)
        
        // Assert
        XCTAssertNil(self.sut.taskFormModel.startDate)
        XCTAssertNil(self.sut.taskFormModel.time)
        XCTAssertNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNil(self.sut.taskFormModel.endDate)
        XCTAssertFalse(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenTimeSetEnabled_OnlyStartDateAndTimeNotNil() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .time), isEnabled: true)
        
        // Assert
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertNotNil(self.sut.taskFormModel.time)
        
        XCTAssertNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertFalse(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenTimeSetDisabled_OnlyTimeIsNil() {
        // Arrange & Act
        self.setupSutWithAllCellsEnabled()
        self.sut.didChangeCellIsEnabled(.init(cellType: .time), isEnabled: false)
        
        // Assert
        XCTAssertNil(self.sut.taskFormModel.time)
        
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertNotNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNotNil(self.sut.taskFormModel.endDate)
        XCTAssertTrue(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenRepeatSettingsSetEnabled_OnlyStartDateAndRepeatSettingsNotNil() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .repeats), isEnabled: true)
        
        // Assert
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertNotNil(self.sut.taskFormModel.repeatSettings)
        
        XCTAssertNil(self.sut.taskFormModel.time)
        XCTAssertNil(self.sut.taskFormModel.endDate)
        XCTAssertFalse(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenRepeatSettingsSetDisabled_OnlyRepeatSettingsAndEndDateNil() {
        // Arrange & Act
        self.setupSutWithAllCellsEnabled()
        self.sut.didChangeCellIsEnabled(.init(cellType: .repeats), isEnabled: false)
        
        // Assert
        XCTAssertNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNil(self.sut.taskFormModel.endDate)
        
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertNotNil(self.sut.taskFormModel.time)
        XCTAssertTrue(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenEndDateSetEnabled_StartDateRepeatSettingsEndDateNotNil() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .repeats), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .endDate), isEnabled: true)
        
        // Assert
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertNotNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNotNil(self.sut.taskFormModel.endDate)
        
        XCTAssertNil(self.sut.taskFormModel.time)
        XCTAssertFalse(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenEndDateSetDisabled_OnlyEndDateNil() {
        // Arrange & Act
        self.setupSutWithAllCellsEnabled()
        self.sut.didChangeCellIsEnabled(.init(cellType: .endDate), isEnabled: false)
        
        // Assert
        XCTAssertNil(self.sut.taskFormModel.endDate)
        
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertNotNil(self.sut.taskFormModel.time)
        XCTAssertNotNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertTrue(self.sut.taskFormModel.notificationsEnabled)
    }
    
    func testTaskFormModel_WhenNotificationsSetEnabled_OnlyStartDateAndNotificationsNotNil() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .notifications), isEnabled: true)
        
        // Assert
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertTrue(self.sut.taskFormModel.notificationsEnabled)
        
        XCTAssertNil(self.sut.taskFormModel.time)
        XCTAssertNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNil(self.sut.taskFormModel.endDate)
    }
    
    func testTaskFormModel_WhenNotificationsSetDisabled_OnlyNotificationsNil() {
        // Arrange & Act
        self.setupSutWithAllCellsEnabled()
        self.sut.didChangeCellIsEnabled(.init(cellType: .notifications), isEnabled: false)
        
        // Assert
        XCTAssertFalse(self.sut.taskFormModel.notificationsEnabled)
        
        XCTAssertNotNil(self.sut.taskFormModel.startDate)
        XCTAssertNotNil(self.sut.taskFormModel.time)
        XCTAssertNotNil(self.sut.taskFormModel.repeatSettings)
        XCTAssertNotNil(self.sut.taskFormModel.endDate)
    }
    
    
    // MARK: - Task Form Model Cells (Array Conaints)
    // NOTE: Title & Description cannot be disabled so their models will always be in the array
    
    func testTaskFormCellModels_WhenNoCellsEnabled_OnlyStartDateInArray() throws {
        let containsTitle = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .title })
        let containsDesc = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .description })
        XCTAssertTrue(containsTitle ?? false)
        XCTAssertTrue(containsDesc ?? false)
        
        let containsStartDate = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .startDate })
        XCTAssertTrue(containsStartDate ?? false)
        
        let containsOtherThanStartDate = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType != .startDate })
        XCTAssertFalse(containsOtherThanStartDate ?? true)
        
        XCTAssertNil(self.sut.taskFormCellModels[optional: 2])
    }
    
    func testTaskFormCellModels_WhenStartDateSetEnabled_StartDateTimeRepeatAndNotificationCellsInArray() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        
        let containsTitle = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .title })
        let containsDesc = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .description })
        XCTAssertTrue(containsTitle ?? false)
        XCTAssertTrue(containsDesc ?? false)

        // Assert
        let containsStartDate = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .startDate })
        let containsTime = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .time })
        let containsRepeating = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .repeats })
        let containsNotifications = self.sut.taskFormCellModels[optional: 2]?.contains(where: { $0.cellType == .notifications })
        
        XCTAssertTrue(containsStartDate ?? false)
        XCTAssertTrue(containsTime ?? false)
        XCTAssertTrue(containsRepeating ?? false)
        XCTAssertTrue(containsNotifications ?? false)
    }
    
    func testTaskFormCellModels_WhenStartDateSetDisabled_OnlyContainsStartDateInArray() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: false)
        
        let containsTitle = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .title })
        let containsDesc = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .description })
        XCTAssertTrue(containsTitle ?? false)
        XCTAssertTrue(containsDesc ?? false)

        // Assert
        let containsOtherThanStartDate = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType != .startDate })
        XCTAssertFalse(containsOtherThanStartDate ?? true)
        
        XCTAssertEqual(self.sut.taskFormCellModels[optional: 1]?.count, 1)
        
        XCTAssertNil(self.sut.taskFormCellModels[optional: 2])
    }
    
    func testTaskFormCellModels_WhenRepeatingSetEnabled_AllCellsDisplayedInArray() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .repeats), isEnabled: true)
        
        let containsTitle = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .title })
        let containsDesc = self.sut.taskFormCellModels[optional: 0]?.contains(where: { $0.cellType == .description })
        XCTAssertTrue(containsTitle ?? false)
        XCTAssertTrue(containsDesc ?? false)
        
        // Assert
        let containsStartDate = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .startDate })
        let containsTime = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .time })
        let containsRepeating = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .repeats })
        let containsEndDate = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .endDate })
        let containsNotifications = self.sut.taskFormCellModels[optional: 2]?.contains(where: { $0.cellType == .notifications })
        
        XCTAssertTrue(containsStartDate ?? false)
        XCTAssertTrue(containsTime ?? false)
        XCTAssertTrue(containsRepeating ?? false)
        XCTAssertTrue(containsEndDate ?? false)
        XCTAssertTrue(containsNotifications ?? false)
    }
    
    func testTaskFormCellModels_WhenRepeatingSetDisabled_EndDateNotInArray() {
        // Arrange & Act
        self.sut.didChangeCellIsEnabled(.init(cellType: .startDate), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .repeats), isEnabled: true)
        self.sut.didChangeCellIsEnabled(.init(cellType: .repeats), isEnabled: false)
        
        // Assert
        let containsEndDate = self.sut.taskFormCellModels[optional: 1]?.contains(where: { $0.cellType == .endDate })
        
        XCTAssertFalse(containsEndDate ?? false)
    }
}


// MARK: - Update Task Form Model (Called from Delegate Functions in Cells)
extension TaskFormControllerViewModelTests {
    func testTaskFormControllerViewModel_UpdateTaskFormModelForTextField_UpdatesTitleInTaskFormModel() {
        // Arrange
        let originalTitle = self.sut.taskFormModel.title
        
        // Act
        self.sut.updateTaskFormModelForTextField(.init(cellType: .title), "My Title")
        
        // Assert
        XCTAssertNil(originalTitle)
        XCTAssertEqual(self.sut.taskFormModel.title, "My Title")
        XCTAssertNotEqual(originalTitle, self.sut.taskFormModel.title)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForTextFieldCalled_UpdatesDescriptionInTaskFormModel() {
        // Arrange
        let originalDescription = self.sut.taskFormModel.description
        
        // Act
        self.sut.updateTaskFormModelForTextField(.init(cellType: .description), "My Description")
        
        // Assert
        XCTAssertNil(originalDescription)
        XCTAssertEqual(self.sut.taskFormModel.description, "My Description")
        XCTAssertNotEqual(originalDescription, self.sut.taskFormModel.description)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForDateCalled_UpdatesStartDateInTaskFormModel() {
        // Arrange
        let originalStartDate = self.sut.taskFormModel.startDate
        let passedInDate = Date()
        
        // Act
        self.sut.updateTaskFormModelForDate(.init(cellType: .startDate), passedInDate)
        
        // Assert
        XCTAssertNil(originalStartDate)
        XCTAssertEqual(self.sut.taskFormModel.startDate, passedInDate)
        XCTAssertNotEqual(originalStartDate, self.sut.taskFormModel.startDate)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForDateCalled_UpdatesTimeInTaskFormModel() {
        // Arrange
        let originalTime = self.sut.taskFormModel.time
        let passedInTime = Date()
        
        // Act
        self.sut.updateTaskFormModelForDate(.init(cellType: .time), passedInTime)
        
        // Assert
        XCTAssertNil(originalTime)
        XCTAssertEqual(self.sut.taskFormModel.time, passedInTime)
        XCTAssertNotEqual(originalTime, self.sut.taskFormModel.time)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForDateCalled_UpdatesEndDateInTaskFormModel() {
        // Arrange
        let originalEndDate = self.sut.taskFormModel.endDate
        let passedInEndDate = Date()
        
        // Act
        self.sut.updateTaskFormModelForDate(.init(cellType: .endDate), passedInEndDate)
        
        // Assert
        XCTAssertNil(originalEndDate)
        XCTAssertEqual(self.sut.taskFormModel.endDate, passedInEndDate)
        XCTAssertNotEqual(originalEndDate, self.sut.taskFormModel.endDate)
    }
    
    func testTaskFormControllerViewModel_UpdateTaskFormModelForRepeatSettingsCalled_UpdatesRepeatSettingsInTaskFormModel() {
        // Arrange
        let originalRepeatSettings = self.sut.taskFormModel.repeatSettings
        let passedInRepeatSettings = RepeatSettings.weekly([1, 5])
        
        // Act
        self.sut.updateTaskFormModelForRepeatSettings(passedInRepeatSettings)
        
        // Assert
        XCTAssertNil(originalRepeatSettings)
        XCTAssertEqual(self.sut.taskFormModel.repeatSettings, passedInRepeatSettings)
        XCTAssertNotEqual(originalRepeatSettings, self.sut.taskFormModel.repeatSettings)
    }
}


// MARK: - Validate Task Form Model
extension TaskFormControllerViewModelTests {

    func testValidateTaskFormModel_WhenPersistenTaskModel_ReturnsPersistentTask() {
        // Arrange
        let title = "My persistent task"
        let desc = "My desc"
        
        self.sut.updateTaskFormModelForTextField(.init(cellType: .title), title)
        self.sut.updateTaskFormModelForTextField(.init(cellType: .description), desc)
        
        // Act
        guard let task = self.sut.validateTaskFormModel(with: self.sut.taskFormModel) else { XCTFail(); return }
        
        // Assert
        switch task {
        case .persistent(let pTask):
            XCTAssertEqual(pTask.title, title)
            XCTAssertEqual(pTask.desc, desc)
            
        case .repeating(_):
            XCTFail()
        case .nonRepeating(_):
            XCTFail()
        }
    }
    
    func testValidateTaskFormModel_WhenNonRepeatingModel_ReturnsNonRepeatingTask() {
        // Arrange
        let title = "My non repeating task"
        let desc = "My desc"
        let startDate = Date()
        let time = Date()
        let notificationsEnabled = true
        
        self.sut.updateTaskFormModelForTextField(.init(cellType: .title), title)
        self.sut.updateTaskFormModelForTextField(.init(cellType: .description), desc)
        self.sut.updateTaskFormModelForDate(.init(cellType: .startDate), startDate)
        self.sut.updateTaskFormModelForDate(.init(cellType: .time), time)
        self.sut.didChangeCellIsEnabled(.init(cellType: .notifications), isEnabled: notificationsEnabled)
        
        // Act
        guard let task = self.sut.validateTaskFormModel(with: self.sut.taskFormModel) else { XCTFail(); return }
        
        // Assert
        switch task {
        case .persistent(_):
            XCTFail()
        case .repeating(_):
            XCTFail()
        case .nonRepeating(let nonRep):
            XCTAssertEqual(nonRep.title, title)
            XCTAssertEqual(nonRep.desc, desc)
            XCTAssertEqual(nonRep.date, startDate)
            XCTAssertEqual(nonRep.time, time)
            XCTAssertTrue(nonRep.notificationsEnabled)
        }
    }
    
    func testValidateTaskFormModel_WhenRepeatingModel_ReturnsRepeatingTask() {
        // Arrange
        let title = "My repeating task"
        let desc = "My desc 123"
        let startDate = Date()
        let repeatSettings: RepeatSettings = .yearly
        let endDate = Date().addingTimeInterval(60*60*24)
        let notificationsEnabled = false
        
        self.sut.updateTaskFormModelForTextField(.init(cellType: .title), title)
        self.sut.updateTaskFormModelForTextField(.init(cellType: .description), desc)
        self.sut.updateTaskFormModelForDate(.init(cellType: .startDate), startDate)
        self.sut.updateTaskFormModelForRepeatSettings(repeatSettings)
        self.sut.updateTaskFormModelForDate(.init(cellType: .endDate), endDate)
        self.sut.didChangeCellIsEnabled(.init(cellType: .notifications), isEnabled: notificationsEnabled)
        
        // Act
        guard let task = self.sut.validateTaskFormModel(with: self.sut.taskFormModel) else { XCTFail(); return }
        
        // Assert
        switch task {
        case .persistent(_):
            XCTFail()
            
        case .repeating(let rTask):
            XCTAssertEqual(rTask.title, title)
            XCTAssertEqual(rTask.desc, desc)
            XCTAssertEqual(rTask.startDate, startDate)
            XCTAssertNil(rTask.time)
            XCTAssertEqual(rTask.repeatSettings, repeatSettings)
            XCTAssertEqual(rTask.endDate, endDate)
            XCTAssertFalse(rTask.notificationsEnabled)
            
        case .nonRepeating(_):
            XCTFail()
        }
    }
}
