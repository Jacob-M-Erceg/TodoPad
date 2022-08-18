//
//  TaskCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-16.
//

import XCTest
@testable import TodoPad

class TaskCellTests: XCTestCase {
    
    var sut: TaskCell!

    override func setUpWithError() throws {
        self.sut = TaskCell()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testTaskCell_WhenConfigured_TaskLabelTitleIsSet() {
        // Arrange
        let nonRep = NonRepeatingTask.getMockNonRepeatingTask
        
        // Act
        self.sut.configure(with: Task.nonRepeating(nonRep), true)
        
        // Assert
        XCTAssertEqual(self.sut.taskLabel.text, nonRep.title)
    }
    
    func testTaskCell_WhenConfiguredWithPersistentTask_TimeLabelIsNil() {
        // Arrange
        let pTask = PersistentTask.getMockPersistentTask
        
        // Act
        self.sut.configure(with: Task.persistent(pTask), false)
        
        // Assert
        XCTAssertEqual(sut.timeLabel.text, nil)
    }
    
    func testTaskCell_WhenConfiguredWithRepeatingTask_TimeLabelIsSet() {
        // Arrange
        let rTask = RepeatingTask.getMockRepeatingTask
        
        // Act
        self.sut.configure(with: Task.repeating(rTask), false)
        
        // Assert
        XCTAssertEqual(sut.timeLabel.text, rTask.time?.timeString)
    }
    
    func testTaskCell_WhenConfiguredWithNonRepeatingTask_TimeLabelIsSet() {
        // Arrange
        let nonRep = NonRepeatingTask.getMockNonRepeatingTask
        
        // Act
        self.sut.configure(with: Task.nonRepeating(nonRep), false)
        
        // Assert
        XCTAssertEqual(sut.timeLabel.text, nonRep.time?.timeString)
    }
    
}
