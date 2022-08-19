//
//  ViewTaskTableViewHeaderTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-18.
//

import XCTest
@testable import TodoPad

class ViewTaskTableViewHeaderTests: XCTestCase, ViewTaskTableViewHeaderDelegate {
    
    func testViewTaskTableViewHeader_WhenInitializedWithNotCompletedTask_LabelsAreSetCorrectly() {
        // Arrange
        let header = ViewTaskTableViewHeader(frame: .zero, title: "My Title", description: nil, taskIsCompleted: false)
        
        // Act
        
        // Assert
        XCTAssertEqual(header.taskTitleLabel.text, "My Title")
        XCTAssertEqual(header.descriptionLabel.text, nil)
        XCTAssertEqual(header.completeButton.titleLabel?.text, "Complete")
    }
    
    func testViewTaskTableViewHeader_WhenInitializedWithtCompletedTask_LabelsAreSetCorrectly() {
        // Arrange
        let header = ViewTaskTableViewHeader(frame: .zero, title: "My Title", description: "My desc", taskIsCompleted: true)
        
        // Act
        
        // Assert
        XCTAssertEqual(header.taskTitleLabel.text, "My Title")
        XCTAssertEqual(header.descriptionLabel.text, "My desc")
        XCTAssertEqual(header.completeButton.titleLabel?.text, "Undo")
    }
    
    // MARK: - Delegate Function
    private var expectation: XCTestExpectation?
    
    func testViewTaskTableViewHeader_WhenCompleteButtonPressed_DelegateFunctionCalled() {
        // Arrange
        let header = ViewTaskTableViewHeader(frame: .zero, title: "My Title", description: nil, taskIsCompleted: false)
        header.delegate = self
        
        // Act
        self.expectation = self.expectation(description: "Expect complete button pressed.")
        header.completeButton.sendActions(for: .touchUpInside)
        
        // Assert
        waitForExpectations(timeout: 1)
    }
    
    func didTapCompleteTask() {
        self.expectation?.fulfill()
    }
    
}
