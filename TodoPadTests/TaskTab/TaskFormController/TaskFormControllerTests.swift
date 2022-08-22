//
//  TaskFormControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-04.
//

import XCTest
@testable import TodoPad

class TaskFormControllerTests: XCTestCase {
    
    var sut: TaskFormController!
    
    // MARK: - Setup
    override func setUpWithError() throws {
        let coreDataContext = CoreDataTestStack().context
        
        let viewModel = TaskFormControllerViewModel(
            selectedDate: Date(),
            taskFormModel: TaskFormModel(),
            originalTask: nil,
            persistentTaskManager: PersistentTaskManager(context: coreDataContext),
            repeatingTaskManager: RepeatingTaskManager(context: coreDataContext),
            nonRepeatingTaskManager: NonRepeatingTaskManager(context: coreDataContext)
        )
        
        self.sut = TaskFormController(viewModel)
        self.sut.loadViewIfNeeded()
    }
    
    private func setupSutInEditMode(task: Task) {
        var viewModel: TaskFormControllerViewModel!
        
        let coreDataContext = CoreDataTestStack().context
        let pTaskMan = PersistentTaskManager(context: coreDataContext)
        let rTaskMan = RepeatingTaskManager(context: coreDataContext)
        let nonRepTaskMan = NonRepeatingTaskManager(context: coreDataContext)
        
        switch task {
        case .persistent(let pTask):
            let taskFormModel = TaskFormModel(for: pTask)
            viewModel = TaskFormControllerViewModel(selectedDate: Date(), taskFormModel: taskFormModel, originalTask: task, persistentTaskManager: pTaskMan, repeatingTaskManager: rTaskMan, nonRepeatingTaskManager: nonRepTaskMan)
            
        case .repeating(let rTask):
            let taskFormModel = TaskFormModel(for: rTask)
            viewModel = TaskFormControllerViewModel(selectedDate: rTask.startDate, taskFormModel: taskFormModel, originalTask: task, persistentTaskManager: pTaskMan, repeatingTaskManager: rTaskMan, nonRepeatingTaskManager: nonRepTaskMan)
            
        case .nonRepeating(let nonRepTask):
            let taskFormModel = TaskFormModel(for: nonRepTask)
            viewModel = TaskFormControllerViewModel(selectedDate: nonRepTask.date, taskFormModel: taskFormModel, originalTask: task, persistentTaskManager: pTaskMan, repeatingTaskManager: rTaskMan, nonRepeatingTaskManager: nonRepTaskMan)
        }
        
        self.sut = TaskFormController(viewModel)
        self.sut.loadViewIfNeeded()
    }
    
    private func setupSutInNewTaskMode(with nonRepTask: NonRepeatingTask) {
        let coreDataContext = CoreDataTestStack().context
        let pTaskMan = PersistentTaskManager(context: coreDataContext)
        let rTaskMan = RepeatingTaskManager(context: coreDataContext)
        let nonRepTaskMan = NonRepeatingTaskManager(context: coreDataContext)
        
        let taskFormModel = TaskFormModel(for: nonRepTask)
        let viewModel = TaskFormControllerViewModel(selectedDate: nonRepTask.date, taskFormModel: taskFormModel, originalTask: nil, persistentTaskManager: pTaskMan, repeatingTaskManager: rTaskMan, nonRepeatingTaskManager: nonRepTaskMan)
        
        self.sut = TaskFormController(viewModel)
        self.sut.loadViewIfNeeded()
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

 
// MARK: - Initialization
extension TaskFormControllerTests {
    func testTaskFormController_WhenNewTaskMode_NavigationTitleIsNewTask() {
        XCTAssertEqual(self.sut.navigationItem.title, "New Task")
    }
    
    func testTaskFormController_WhenEditTaskMode_NavigationTitleIsEditTask() {
        self.setupSutWithAllCellsEnabled()
        XCTAssertEqual(self.sut.navigationItem.title, "Edit Task")
    }
    
    func testTaskFormController_WhenNewTaskMode_SaveButtonTitleIsAdd() {
        XCTAssertEqual(self.sut.navigationItem.rightBarButtonItem?.title, "Add")
    }
    
    func testTaskFormController_WhenEditTaskMode_SaveButtonTitleIsSave() {
        self.setupSutWithAllCellsEnabled()
        XCTAssertEqual(self.sut.navigationItem.rightBarButtonItem?.title, "Save")
    }
}

// MARK: - didClickSave Selector
extension TaskFormControllerTests {
    
    func testDidClickSave_NewTask_NotificationSaved() {
        // Arrange
        let nonRepTask = NonRepeatingTask(title: "My NonRep Task", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date().addingTimeInterval(60*60*24*3), time: nil, notificationsEnabled: true)
        self.setupSutInNewTaskMode(with: nonRepTask)
        
        let expectation = self.expectation(description: "Save notification for new task.")
        
        // Act & Assert
        NotificationManager.getAllPendingNotifications { beforeRequests in
            let containsNotificationAlready = beforeRequests.contains(where: { $0.identifier == nonRepTask.taskUUID.uuidString })
            XCTAssertFalse(containsNotificationAlready)
            
            DispatchQueue.main.sync {
                // Presses add button
                let addButton = self.sut.navigationItem.rightBarButtonItem
                let _ = addButton?.target?.perform(addButton?.action, with: nil)
            }
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+1) {
                NotificationManager.getAllPendingNotifications { requests in
                    let containsNotification = requests.contains(where: { $0.identifier == nonRepTask.taskUUID.uuidString })
                    XCTAssertTrue(containsNotification)
                    expectation.fulfill()
                    NotificationManager.removeNotifications(for: Task.nonRepeating(nonRepTask))
                }
            }
        }
        waitForExpectations(timeout: 3)
    }
    
    // MARK: - Save New Task
    func testDidClickSave_WhenNewPersistenTask_SavesNewPersistentTaskToCoreData() {
        // Arrange
        let initialCount = self.sut.viewModel.persistentTaskManager.fetchPersistentTasks().count
        XCTAssertEqual(initialCount, 0)
        
        self.sut.didEditTextField(.init(cellType: .title), "My Persistent Task")
        self.sut.didEditTextField(.init(cellType: .description), "My description")
        
        // Act
        let addButton = self.sut.navigationItem.rightBarButtonItem
        let _ = addButton?.target?.perform(addButton?.action, with: nil)
        
        // Assert
        let afterCount = self.sut.viewModel.persistentTaskManager.fetchPersistentTasks().count
        XCTAssertEqual(afterCount, 1)
    }
    
    func testDidClickSave_WhenNewRepeatingTask_SavesNewRepeatingTaskToCoreData() {
        // Arrange
        let initialCount = self.sut.viewModel.repeatingTaskManager.fetchAllRepeatingTasks().count
        XCTAssertEqual(initialCount, 0)
        
        self.sut.didEditTextField(.init(cellType: .title), "My Repeating Task")
        self.sut.didChangeCellIsEnabled(taskFormCellModel: .init(cellType: .startDate), isEnabled: true)
        self.sut.didChangeCellIsEnabled(taskFormCellModel: .init(cellType: .time), isEnabled: true)
        self.sut.didChangeCellIsEnabled(taskFormCellModel: .init(cellType: .repeats), isEnabled: true)
        
        // Act
        let addButton = self.sut.navigationItem.rightBarButtonItem
        let _ = addButton?.target?.perform(addButton?.action, with: nil)
        
        // Assert
        let afterCount = self.sut.viewModel.repeatingTaskManager.fetchAllRepeatingTasks().count
        XCTAssertEqual(afterCount, 1)
    }
    
    func testDidClickSave_WhenNewNonRepeatingTask_SavesNewNonRepeatingTaskToCoreData() {
        // Arrange
        let initialCount = self.sut.viewModel.nonRepeatingTaskManager.fetchNonRepeatingTasks(for: self.sut.viewModel.selectedDate).count
        XCTAssertEqual(initialCount, 0)
        
        self.sut.didEditTextField(.init(cellType: .title), "My Repeating Task")
        self.sut.didChangeCellIsEnabled(taskFormCellModel: .init(cellType: .startDate), isEnabled: true)
        
        // Act
        let addButton = self.sut.navigationItem.rightBarButtonItem
        let _ = addButton?.target?.perform(addButton?.action, with: nil)
        
        // Assert
        let afterCount = self.sut.viewModel.nonRepeatingTaskManager.fetchNonRepeatingTasks(for: self.sut.viewModel.selectedDate).count
        XCTAssertEqual(afterCount, 1)
    }
    
    // MARK: - Save Edited Task
    func testDidClickSave_WhenEditingPersistentTask_SavesUpdatedPersistentTaskToCoreData() {
        // Arrange
        let initalPTask = PersistentTask(title: "My pTask", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        self.setupSutInEditMode(task: Task.persistent(initalPTask))
        
        self.sut.viewModel.persistentTaskManager.saveNewPersistentTask(with: initalPTask)
        XCTAssertEqual(self.sut.viewModel.persistentTaskManager.fetchPersistentTasks().count, 1)
        
        // Act
        self.sut.didEditTextField(.init(cellType: .title), "My pTask Updated")
        self.sut.didEditTextField(.init(cellType: .description), "My Description")
        
        let addButton = self.sut.navigationItem.rightBarButtonItem
        let _ = addButton?.target?.perform(addButton?.action, with: nil)
        
        // Assert
        let afterPTask = self.sut.viewModel.persistentTaskManager.fetchPersistentTasks().first
        
        XCTAssertNotEqual(initalPTask.title, afterPTask?.title)
        XCTAssertNotEqual(initalPTask.desc, afterPTask?.desc)
        XCTAssertEqual(initalPTask.taskUUID, afterPTask?.taskUUID)
        
        XCTAssertEqual(self.sut.viewModel.persistentTaskManager.fetchPersistentTasks().count, 1)
    }
    
    func testDidClickSave_WhenEditingRepeatingTask_SavesUpdatedRepeatingTaskToCoreData() {
        // Arrange
        let initialRTask = RepeatingTask(title: "My rTask", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date(), time: Date(), repeatSettings: .daily, endDate: Date().addingTimeInterval(60*60*24*7), notificationsEnabled: false)
        self.setupSutInEditMode(task: Task.repeating(initialRTask))
        
        self.sut.viewModel.repeatingTaskManager.saveNewRepeatingTask(with: initialRTask)
        XCTAssertEqual(self.sut.viewModel.repeatingTaskManager.fetchAllRepeatingTasks().count, 1)
        
        // Act
        self.sut.didEditTextField(.init(cellType: .title), "My rTask Updated")
        self.sut.didEditTextField(.init(cellType: .description), "My Description")
        self.sut.didEditDatePicker(.init(cellType: .startDate), Date().addingTimeInterval(60*60*24))
        self.sut.didEditDatePicker(.init(cellType: .time), Date().addingTimeInterval(60*3))
        self.sut.didChangeRepeatSettings(.weekly([1, 2, 5]))
        self.sut.didEditDatePicker(.init(cellType: .endDate), Date().addingTimeInterval(60*60*24*14))
        
        let addButton = self.sut.navigationItem.rightBarButtonItem
        let _ = addButton?.target?.perform(addButton?.action, with: nil)
        
        // Assert
        let afterRTask = self.sut.viewModel.repeatingTaskManager.fetchAllRepeatingTasks().first
        
        XCTAssertNotEqual(initialRTask.title, afterRTask?.title)
        XCTAssertNotEqual(initialRTask.desc, afterRTask?.desc)
        XCTAssertNotEqual(initialRTask.startDate.startOfDay, afterRTask?.startDate)
        XCTAssertNotEqual(initialRTask.time, afterRTask?.time)
        XCTAssertNotEqual(initialRTask.repeatSettings, afterRTask?.repeatSettings)
        XCTAssertNotEqual(initialRTask.endDate, afterRTask?.endDate)
        XCTAssertEqual(initialRTask.taskUUID, afterRTask?.taskUUID)
        
        XCTAssertEqual(self.sut.viewModel.repeatingTaskManager.fetchAllRepeatingTasks().count, 1)
    }
    
    func testDidClickSave_WhenEditingNonRepeatingTask_SavesUpdatedNonRepeatingTaskToCoreData() {
        // Arrange
        let initialNonRepTask = NonRepeatingTask(title: "My nonRepTask", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date(), time: Date(), notificationsEnabled: false)
        self.setupSutInEditMode(task: Task.nonRepeating(initialNonRepTask))
        
        self.sut.viewModel.nonRepeatingTaskManager.saveNewNonRepeatingTask(with: initialNonRepTask)
        XCTAssertEqual(self.sut.viewModel.nonRepeatingTaskManager.fetchNonRepeatingTasks(for: Date()).count, 1)
        
        // Act
        self.sut.didEditTextField(.init(cellType: .title), "My nonRepTask Updated")
        self.sut.didEditTextField(.init(cellType: .description), "My Description")
        self.sut.didEditDatePicker(.init(cellType: .startDate), Date().addingTimeInterval(60))
        self.sut.didEditDatePicker(.init(cellType: .time), Date().addingTimeInterval(60*3))
        
        let addButton = self.sut.navigationItem.rightBarButtonItem
        let _ = addButton?.target?.perform(addButton?.action, with: nil)
        
        // Assert
        let afterNonRepTask = self.sut.viewModel.nonRepeatingTaskManager.fetchNonRepeatingTasks(for: Date()).first
        
        XCTAssertNotEqual(initialNonRepTask.title, afterNonRepTask?.title)
        XCTAssertNotEqual(initialNonRepTask.desc, afterNonRepTask?.desc)
        XCTAssertNotEqual(initialNonRepTask.date, afterNonRepTask?.date)
        XCTAssertNotEqual(initialNonRepTask.time, afterNonRepTask?.time)
        XCTAssertEqual(initialNonRepTask.taskUUID, afterNonRepTask?.taskUUID)
        
        XCTAssertEqual(self.sut.viewModel.nonRepeatingTaskManager.fetchNonRepeatingTasks(for: Date()).count, 1)
    }
}



// MARK: - TableView
extension TaskFormControllerTests {
    
    // MARK: - Section/Row Count
    func testTableView_NumberOfSections_WhenNewTaskForm_ReturnsTwoSections() {
        // Arrange
        let sectionCount = self.sut.tableView.dataSource?.numberOfSections?(in: self.sut.tableView)
        
        // Assert
        XCTAssertEqual(sectionCount, 2)
    }
    
    func testTableView_NumberOfRowsInSection_WhenNewTaskForm() {
        // Arrange
        let sectionOneCount = self.sut.tableView.dataSource?.tableView(self.sut.tableView, numberOfRowsInSection: 0)
        let sectionTwoCount = self.sut.tableView.dataSource?.tableView(self.sut.tableView, numberOfRowsInSection: 1)
        
        // Assert
        XCTAssertEqual(sectionOneCount, 2)
        XCTAssertEqual(sectionTwoCount, 1)
    }
    
    
    // MARK: - Cell For Row At
    func testTableView_CellForRowAt_TextFieldCellsSetupCorrectly() {
        // Arrange
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 0, section: 0)
        let indexPath2 = IndexPath(row: 1, section: 0)
        
        XCTAssertEqual(self.sut.viewModel.taskFormCellModels[indexPath.section][indexPath.row].cellType, .title)
        XCTAssertEqual(self.sut.viewModel.taskFormCellModels[indexPath2.section][indexPath2.row].cellType, .description)
        
        // Act
        let cell1 = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: indexPath) as? TaskFormTextFieldCell
        let cell2 = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: indexPath2) as? TaskFormTextFieldCell
        
        // Assert
        XCTAssertNotNil(cell1)
        XCTAssertNotNil(cell2)
    }
    
    func testTableView_CellForRowAt_DatePickerCellsSetupCorrectly() {
        // Arrange
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 0, section: 1)
        let indexPath2 = IndexPath(row: 1, section: 1)
        let indexPath3 = IndexPath(row: 3, section: 1)
        
        XCTAssertEqual(self.sut.viewModel.taskFormCellModels[indexPath.section][indexPath.row].cellType, .startDate)
        XCTAssertEqual(self.sut.viewModel.taskFormCellModels[indexPath2.section][indexPath2.row].cellType, .time)
        XCTAssertEqual(self.sut.viewModel.taskFormCellModels[indexPath3.section][indexPath3.row].cellType, .endDate)
        
        // Act
        let cell1 = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: indexPath) as? TaskFormDatePickerCell
        let cell2 = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: indexPath2) as? TaskFormDatePickerCell
        let cell3 = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: indexPath3) as? TaskFormDatePickerCell
        
        // Assert
        XCTAssertNotNil(cell1)
        XCTAssertNotNil(cell2)
        XCTAssertNotNil(cell3)
    }
    
    func testTableView_CellForRowAt_RepeatSettingsCellSetupCorrectly() {
        // Arrange
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 2, section: 1)
        
        XCTAssertEqual(self.sut.viewModel.taskFormCellModels[indexPath.section][indexPath.row].cellType, .repeats)
        
        // Act
        let cell = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: indexPath) as? TaskFormRepeatSettingsCell
        
        // Assert
        XCTAssertNotNil(cell)
    }
    
    func testTableView_CellForRowAt_NotificationsCellSetupCorrectly() {
        // Arrange
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 0, section: 2)
        
        XCTAssertEqual(self.sut.viewModel.taskFormCellModels[indexPath.section][indexPath.row].cellType, .notifications)
        
        // Act
        let cell = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: indexPath) as? TaskFormNotificationCell
        
        // Assert
        XCTAssertNotNil(cell)
    }
    
    
    // MARK: - Height For Row
    func testTableView_HeightForRowAt_AnyNonExpandedCell_Returns66() {
        // Arrange & Act
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // Assert
        XCTAssertEqual(height, 66)
    }
    
    func testTableView_HeightForRowAt_ExpandedTextFieldCell_Returns66() {
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Act
        self.sut.viewModel.invertIsExpanded(indexPath)
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: indexPath)
        
        XCTAssertEqual(height, 66)
    }
    
    func testTableView_HeightForRowAt_ExpandedDatePickerCell_Returns121() {
        // Arrange
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 0, section: 1)
        
        // Act
        self.sut.viewModel.invertIsExpanded(indexPath)
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: indexPath)
        
        // Assert
        XCTAssertEqual(height, 121)
    }
    
    func testTableView_HeightForRowAt_ExpandedRepeatSettingsCell_Returns222() {
        // Arrange
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 2, section: 1)
        
        // Act
        self.sut.viewModel.invertIsExpanded(indexPath)
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: indexPath)
        
        // Assert
        XCTAssertEqual(height, 232)
    }
    
    func testTableView_HeightForRowAt_ExpandedNotificationCell_Returns66() {
        self.setupSutWithAllCellsEnabled()
        let indexPath = IndexPath(row: 0, section: 2)
        
        // Act
        self.sut.viewModel.invertIsExpanded(indexPath)
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: indexPath)
        
        XCTAssertEqual(height, 66)
    }
}
