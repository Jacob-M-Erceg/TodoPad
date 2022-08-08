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
        let nonRepTask = NonRepeatingTask(title: "Eat Broccoli", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date(), time: nil, notificationsEnabled: false)
        let taskFormModel = TaskFormModel(for: nonRepTask)
        self.sutEditTask = TaskFormControllerViewModel(nonRepTask.date, taskFormModel, Task.nonRepeating(nonRepTask))
    }
    
    override func tearDownWithError() throws {
        
    }
    
    
    // MARK: - Tests
    func testTaskFormControllerViewModel_WhenNoOriginalTaskPassedIn_TaskFormModeIsNewTask() {
        XCTAssertEqual(self.sutNewTask.taskFormMode, TaskFormControllerViewModel.TaskFormMode.newTask)
    }
    
    func testTaskFormControllerViewModel_WheOriginalTaskPassedIn_TaskFormModeIsEditTask() {
        XCTAssertEqual(self.sutEditTask.taskFormMode, TaskFormControllerViewModel.TaskFormMode.editTask)
    }
    
}
