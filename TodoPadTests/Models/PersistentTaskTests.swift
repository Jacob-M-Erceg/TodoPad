//
//  PersistentTaskTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-05.
//

import XCTest
@testable import TodoPad

class PersistentTaskTests: XCTestCase {
    
    func testPersistentTask_WhenDateCompletedNil_IsCompletedIsFalse() {
        // Arrange
        let sut = PersistentTask(title: "Finish Homework", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        
        // Assert
        XCTAssertFalse(sut.isCompleted)
    }
    
    func testPersistentTask_WhenDateCompletedNotNil_IsCompletedIsTrue() {
        // Arrange
        let sut = PersistentTask(title: "Finish Homework", desc: nil, taskUUID: UUID(), dateCompleted: Date())
        
        // Assert
        XCTAssertTrue(sut.isCompleted)
    }
}
