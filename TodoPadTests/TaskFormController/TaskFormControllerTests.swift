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
        let nonRepTask = NonRepeatingTask(title: "Eat Broccoli", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date(), time: nil, notificationsEnabled: false)
        let taskFormModel = TaskFormModel(for: nonRepTask)
        let vmEditTask = TaskFormControllerViewModel(nonRepTask.date, taskFormModel, Task.nonRepeating(nonRepTask))
        self.sutEditTask = TaskFormController(vmEditTask)
        self.sutEditTask.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        self.sutNewTask = nil
        self.sutEditTask = nil
    }
    
    
    // MARK: - Tests
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
