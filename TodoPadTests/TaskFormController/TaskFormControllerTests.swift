//
//  TaskFormControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-04.
//

import XCTest
@testable import TodoPad

class TaskFormControllerTests: XCTestCase {
    
    var sutNewTask: TaskFormController!
    var sutEditTask: TaskFormController!
    
    
    // MARK: - Setup
    override func setUpWithError() throws {
        // SutNewTask
        let vmNewTask = TaskFormControllerViewModel(Date(), TaskFormModel(), nil)
        self.sutNewTask = TaskFormController(vmNewTask)
        self.sutNewTask.loadViewIfNeeded()
        
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
        let vmEditTask = TaskFormControllerViewModel(repeatingTask.startDate, taskFormModel, Task.repeating(repeatingTask))
        self.sutEditTask = TaskFormController(vmEditTask)
        self.sutEditTask.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        self.sutNewTask = nil
        self.sutEditTask = nil
    }
}

 
// MARK: - Initialization
extension TaskFormControllerTests {
    func testTaskFormController_WhenNewTaskMode_NavigationTitleIsNewTask() {
        XCTAssertEqual(self.sutNewTask.navigationItem.title, "New Task")
    }
    
    func testTaskFormController_WhenEditTaskMode_NavigationTitleIsEditTask() {
        XCTAssertEqual(self.sutEditTask.navigationItem.title, "Edit Task")
    }
    
    func testTaskFormController_WhenNewTaskMode_SaveButtonTitleIsAdd() {
        XCTAssertEqual(self.sutNewTask.navigationItem.rightBarButtonItem?.title, "Add")
    }
    
    func testTaskFormController_WhenNewTaskMode_SaveButtonTitleIsSave() {
        XCTAssertEqual(self.sutEditTask.navigationItem.rightBarButtonItem?.title, "Save")
    }
}


// MARK: - CollectionView
extension TaskFormControllerTests {
    
    func testTaskFormController_CollectionView_numberOfSections() {
        // Arrange
        let sectionCount = self.sutNewTask.tableView.dataSource?.numberOfSections?(in: self.sutNewTask.tableView)
        
        // Assert
        XCTAssertEqual(sectionCount, 2)
    }
    
}
