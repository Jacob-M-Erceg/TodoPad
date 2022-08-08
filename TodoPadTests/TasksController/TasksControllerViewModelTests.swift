//
//  TasksControllerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-03.
//

import XCTest
@testable import TodoPad

class TasksControllerViewModelTests: XCTestCase {
    
    var sut: TasksControllerViewModel!

    override func setUpWithError() throws {
        sut = TasksControllerViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTasksControllerViewModel_WhenInitalized_SelectedDateIsToday() {
        // Assert
        XCTAssertEqual(
            sut.selectedDate.timeIntervalSince1970,
            Date().timeIntervalSince1970,
            accuracy: 0.1,
            "When TasksControllerViewModel was initialized the selectedDate variable was not today."
        )
    }
    
    func testTasksControllerViewModel_WhenChangeSelectedDateCalled_SelectedDateChanges() {
        // Arrange
        let originalDate = sut.selectedDate
        
        // Act
        sut.changeSelectedDate(with: Date().addingTimeInterval(60*60*24*99))
        
        // Assert
        XCTAssertNotEqual(
            originalDate.timeIntervalSince1970,
            sut.selectedDate.timeIntervalSince1970,
            accuracy: 0.1,
            "When TasksControllerViewModel.changeSelectedDate() was called, the selectedDate variable did not change."
        )
    }

}
