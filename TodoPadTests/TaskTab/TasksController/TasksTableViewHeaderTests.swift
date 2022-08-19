//
//  TasksTableViewHeaderTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-03.
//

import XCTest
@testable import TodoPad


class TasksTableViewHeaderTests: XCTestCase {
    
    var sut: TasksTableViewHeader!

    override func setUpWithError() throws {
        sut = TasksTableViewHeader()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // TODO - Maybe this test is unnessesary
    func testTasksTableViewHeader_WhenDidTapAddNewTaskCalled_DidTapAddNewTaskDelegateFunctionIsCalled() throws {
        // Arrange
        let mockDelegate = MockTasksTableViewHeaderDelegate(testCase: self)
        sut.delegate = mockDelegate
        
        // Act
        mockDelegate.expect()
        sut.delegate.didTapAddNewTask()
//        sut.didTapAddButton() // Private
        
        // Assert
        waitForExpectations(timeout: 1)
        
        XCTAssertTrue(mockDelegate.wasCalled)
    }
}
