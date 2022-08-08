//
//  TasksControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-03.
//

import XCTest
@testable import TodoPad

class TasksControllerTests: XCTestCase {
    
    var sut: TasksController!

    override func setUpWithError() throws {
        sut = TasksController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
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
            accuracy: 0.1,
            "When TasksControllerViewModel.changeSelectedDate() was called, the selectedDate variable did not change."
        )
    }
    
    func testTasksController_WhenDidTapAddNewTaskDelegateFunctionCalled_NavigateToTaskFormController() {
        // Arrange
        let spyNavController = SpyNavigationController(rootViewController: sut)
        
        // Act
        sut.didTapAddNewTask()
        
        // Assert
        guard let _ = spyNavController.pushedViewController as? TaskFormController else {
            XCTFail("TaskFormController was not presented when the TasksController.didTapAddNewTask delegate method was called.")
            return
        }
    }

}
