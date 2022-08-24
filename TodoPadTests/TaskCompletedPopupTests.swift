//
//  TaskCompletedPopupTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-23.
//

import XCTest
@testable import TodoPad

class TaskCompletedPopupTests: XCTestCase {
    
    var sut: TaskCompletedPopup!

    override func setUpWithError() throws {
        self.sut = TaskCompletedPopup()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testTaskCompletedPopup_WhenConfiguredWith1_Returns1() {
        // Arrange & Act
        self.sut.configure(tasksCompleted: 1)
        
        // Assert
        XCTAssertEqual(self.sut.tasksCompletedLabel.text, 1.description + " Tasks Completed")
    }
    
    func testTaskCompletedPopup_WhenConfiguredWith100_Returns100() {
        // Arrange & Act
        self.sut.configure(tasksCompleted: 100)
        
        // Assert
        XCTAssertEqual(self.sut.tasksCompletedLabel.text, 100.description + " Tasks Completed")
    }
}
