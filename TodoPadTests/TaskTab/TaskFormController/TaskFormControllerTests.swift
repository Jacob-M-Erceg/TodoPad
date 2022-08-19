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
        // SutNewTask
        let viewModel = TaskFormControllerViewModel(Date(), TaskFormModel(), nil)
        self.sut = TaskFormController(viewModel)
        self.sut.loadViewIfNeeded()
    }
    
    private func setupSutInEditMode(task: Task) {
        var viewModel: TaskFormControllerViewModel!
        
        switch task {
        case .persistent(let pTask):
            let taskFormModel = TaskFormModel(for: pTask)
            viewModel = TaskFormControllerViewModel(Date(), taskFormModel, task)
            
        case .repeating(let rTask):
            let taskFormModel = TaskFormModel(for: rTask)
            viewModel = TaskFormControllerViewModel(rTask.startDate, taskFormModel, task)
            
        case .nonRepeating(let nonRepTask):
            let taskFormModel = TaskFormModel(for: nonRepTask)
            viewModel = TaskFormControllerViewModel(nonRepTask.date, taskFormModel, task)
        }
        
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
