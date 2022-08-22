//
//  TasksControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-03.
//

import XCTest
@testable import TodoPad

class TasksControllerTests: XCTestCase {
    
    var sut: MockTasksController!
    
    override func setUpWithError() throws {
        // Setup Tasks in ViewModel
        let testContext = CoreDataTestStack().context
        let pTaskManger = PersistentTaskManager(context: testContext)
        
        for pTask in PersistentTask.getMockPersistentTaskArray {
            pTaskManger.saveNewPersistentTask(with: pTask)
        }
        
        let viewModel = TasksControllerViewModel(persistentTaskManager: pTaskManger)
        self.sut = MockTasksController(viewModel: viewModel)
        self.sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
}


extension TasksControllerTests {
    func testTasksController_WhenLoaded_NavigationDateTitleIsSet() {
        XCTAssertEqual(DateHelper.getMonthAndDayString(for: Date()), sut.navigationItem.title)
    }
    
    func testTasksController_WhenDatePickerChanged_NavigationDateTitleIsChanged() {
        // Arrange
        let oldDateString = sut.navigationItem.title
        
        // Act
        sut.didChangeDate(with: Date().addingTimeInterval(60*60*24*3))
        
        // Assert
        XCTAssertNotEqual(oldDateString, sut.navigationItem.title)
    }
    
    func testTasksController_WhenDatePickerChanged_ViewModelSelectedDateChanged() {
        // Arrange
        let originalDate = sut.viewModel.selectedDate
        
        // Act
        sut.didChangeDate(with: Date().addingTimeInterval(60*60*24*3))
        
        // Assert
        XCTAssertNotEqual(
            originalDate.timeIntervalSince1970,
            sut.viewModel.selectedDate.timeIntervalSince1970,
            "When TasksControllerViewModel.changeSelectedDate() was called, the selectedDate variable did not change."
        )
    }
    
    func testTasksController_WhenSettingsButtonTapped_NavigateToSettingsController() {
        // Arrange
        let spyNavController = SpyNavigationController(rootViewController: self.sut)
        
        // Act
        let settingsButton = self.sut.navigationItem.rightBarButtonItem
        let _ = settingsButton?.target?.perform(settingsButton?.action, with: nil)
        
        // Assert
        guard let _ = spyNavController.pushedViewController as? SettingsController else {
            XCTFail("SettingsController was not presented when the TasksController.didTapSettings selctor method was called.")
            return
        }
    }
    
}


// MARK: - TableView - Cell Headers
extension TasksControllerTests {
    
    
    func testTableViewCellHeader_NumberOfSections_EqualToViewModelTaskGroups() {
        // Arrange
        let count = self.sut.tableView.dataSource?.numberOfSections?(in: self.sut.tableView)
        
        // Assert
        XCTAssertEqual(count, self.sut.viewModel.taskGroups.count)
    }
    
    func testTableViewCellHeader_ViewForHeaderInSection_CellsNotNill() {
        // Arrange
        let cellOne = self.sut.tableView.delegate?.tableView?(self.sut.tableView, viewForHeaderInSection: 0) as? TaskGroupCell
        let cellTwo = self.sut.tableView.delegate?.tableView?(self.sut.tableView, viewForHeaderInSection: 1) as? TaskGroupCell
        
        // Assert
        XCTAssertNotNil(cellOne)
        XCTAssertNotNil(cellTwo)
    }
    
    func testTableViewCellHeader_HeightForHeaderInSection_Is44() {
        // Arrange
        let headerHeight = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForHeaderInSection: 0)
        
        // Assert
        XCTAssertEqual(headerHeight, 44)
    }
    
    // TODO - Uncomment this
    //    func testTableViewHeader_didTapTaskGroupCellCalled_OpensOrClosesTaskGroup() {
    //        // Arrange
    //        let taskGroup = self.sut.viewModel.taskGroups[0]
    //
    //        // Act
    //        self.sut.didTapTaskGroupCell(for: taskGroup)
    //        XCTAssertNotEqual(taskGroup.isOpened, self.sut.viewModel.taskGroups[0].isOpened)
    //
    //        self.sut.didTapTaskGroupCell(for: taskGroup)
    //        XCTAssertEqual(taskGroup.isOpened, self.sut.viewModel.taskGroups[0].isOpened)
    //    }
}


// MARK: - TableView - Main Cells
extension TasksControllerTests {
    
    func testTableViewCell_NumberOfRowsInSection_IsEqualToTaskGroupTaskCount() {
        // Arrange
        let inProgressCount = self.sut.tableView.dataSource?.tableView(self.sut.tableView, numberOfRowsInSection: 0)
        let completedCount = self.sut.tableView.dataSource?.tableView(self.sut.tableView, numberOfRowsInSection: 1)
        
        // Assert
        XCTAssertEqual(inProgressCount, self.sut.viewModel.taskGroups[0].tasks.count)
        XCTAssertEqual(completedCount, self.sut.viewModel.taskGroups[1].tasks.count)
    }
    
    // TODO - Couldnt get this working
    //    func testTableViewCell_CellForRowAt_CellNotNil() {
    //        // Arrange
    //
    //        devPrint(self.sut.viewModel.taskGroups[0].tasks.count)
    //        devPrint(self.sut.viewModel.taskGroups[1].tasks.count)
    //
    //        let cell = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
    //
    //        // Assert
    //        XCTAssertNotNil(cell)
    //    }
    
    func testTableViewCell_HeightForRowAt_Returns66() {
        // Arrange
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // Assert
        XCTAssertEqual(height, 66)
    }
    
    func testTableViewCell_DidSelectRowAt_NavigateToViewTaskController() {
        // Act
        self.sut.tableView.delegate?.tableView?(self.sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // Assert
        guard let _ = (self.sut.spyPresentedViewController as? UINavigationController)?.topViewController as? ViewTaskController else {
            XCTFail("ViewTaskController was not presented when the TasksController.didSelectRowAt delegate method was called.")
            return
        }
    }
}


// MARK: - Add/Edit Tasks
extension TasksControllerTests {
    
    func testTasksController_WhenDidTapAddNewTaskDelegateFunctionCalled_NavigateToTaskFormController() {
        // Arrange
        let spyNavController = SpyNavigationController(rootViewController: self.sut)
        
        // Act
        self.sut.didTapAddNewTask()
        
        // Assert
        guard let _ = spyNavController.pushedViewController as? TaskFormController else {
            XCTFail("TaskFormController was not presented when the TasksController.didTapAddNewTask delegate method was called.")
            return
        }
    }
    
    func testTasksController_WhenDidTapEditTaskCalled_NavigateToTaskFormController() {
        // Arrange
        let spyNavController = SpyNavigationController(rootViewController: self.sut)
        let pTask = PersistentTask(title: "My PersistentTask", desc: "my desc", taskUUID: UUID(), dateCompleted: nil)
        
        // Act
        self.sut.didTapEditTask(for: Task.persistent(pTask))
        
        // Assert
        guard let _ = spyNavController.pushedViewController as? TaskFormController else {
            XCTFail("TaskFormController was not presented when the TasksController.didTapEditTask method was called.")
            return
        }
    }
}

// MARK: - Show Task Completed Popup
extension TaskFormControllerTests {
    // TODO - 
}
