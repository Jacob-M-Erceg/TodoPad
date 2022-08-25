//
//  TaskGroupCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-11.
//

import XCTest
@testable import TodoPad

class TaskGroupCellTests: XCTestCase, TaskGroupCellDelegate {
    
    // MARK: - Delegate Test
    var taskGroup: TaskGroup!
    private var expectation: XCTestExpectation?
    
    func testTaskGroupCell_WhenCellTapped_DelegateFunctionCalled() {
        // Arrange
        let cell = TaskGroupCell()
        cell.configure(with: TaskGroup(title: "In Progress", isOpened: false, tasks: []))
        cell.delegate = self
        
        // Act
        self.expectation = self.expectation(description: "Expect TaskGroupCell Delegate Called")
        cell.didTapHeader()
        
        // Assert
        waitForExpectations(timeout: 1)
        XCTAssertEqual(self.taskGroup.title, "In Progress", "The TaskGroup model from the delegate function is not the same as the TaskGroup passed into TaskGroupCell")
        XCTAssertEqual(self.taskGroup.isOpened, false, "The TaskGroup model from the delegate function is not the same as the TaskGroup passed into TaskGroupCell")
        XCTAssertEqual(self.taskGroup.tasks .count, 0, "The TaskGroup model from the delegate function is not the same as the TaskGroup passed into TaskGroupCell")
    }
    
    func didTapTaskGroupCell(for taskGroup: TaskGroup) {
        self.taskGroup = taskGroup
        self.expectation?.fulfill()
    }
    
    // MARK: - UI Tests
    func testTaskGroupCell_WhenConfigured_LabelTextTitleCorrect() {
        // Arrange
        let cell = TaskGroupCell()
        cell.configure(with: TaskGroup(title: "In Progress", isOpened: false, tasks: []))
        
        // Assert
        XCTAssertEqual(cell.label.text, "In Progress", "TaskGroupCell label text was not set correctly when configured.")
    }
    
    func testTaskGroupCell_WhenConfiguredWithCellOpened_CorrectImageViewImageSet() {
        // Arrange
        let cell = TaskGroupCell()
        cell.configure(with: TaskGroup(title: "In Progress", isOpened: true, tasks: []))
        
        // Assert
        XCTAssertEqual(cell.imageView.image, UIImage(systemName: "chevron.down"), "TaskGroupCell arrow image not pointing down when the cell is opened.")
    }
    
    func testTaskGroupCell_WhenConfiguredWithCellClosed_CorrectImageViewImageSet() {
        // Arrange
        let cell = TaskGroupCell()
        cell.configure(with: TaskGroup(title: "In Progress", isOpened: false, tasks: []))
        
        // Assert
        XCTAssertEqual(cell.imageView.image, UIImage(systemName: "chevron.up"), "TaskGroupCell arrow image not pointing up when the cell is closed.")
    }
}
