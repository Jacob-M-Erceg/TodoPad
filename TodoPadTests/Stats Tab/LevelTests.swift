//
//  LevelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-23.
//

import XCTest
@testable import TodoPad

class LevelTests: XCTestCase {
    
    func testLevel1() {
        // Arrange
        let level = Level(tasksCompleted: 2)
        
        // Assert
        XCTAssertEqual(level.tasksCompleted, 2)
        XCTAssertEqual(level.levelString, "Level 1")
        XCTAssertEqual(level.nextLevel, 50)
    }
    
    func testLevel2() {
        // Arrange
        let level = Level(tasksCompleted: 50)
        
        // Assert
        XCTAssertEqual(level.tasksCompleted, 50)
        XCTAssertEqual(level.levelString, "Level 2")
        XCTAssertEqual(level.nextLevel, 250)
    }

    func testLevel3() {
        // Arrange
        let level = Level(tasksCompleted: 250)
        
        // Assert
        XCTAssertEqual(level.tasksCompleted, 250)
        XCTAssertEqual(level.levelString, "Level 3")
        XCTAssertEqual(level.nextLevel, 1000)
    }
    
    func testLevel4() {
        // Arrange
        let level = Level(tasksCompleted: 1000)
        
        // Assert
        XCTAssertEqual(level.tasksCompleted, 1000)
        XCTAssertEqual(level.levelString, "Level 4")
        XCTAssertEqual(level.nextLevel, 5000)
    }
    
    func testLevel5() {
        // Arrange
        let level = Level(tasksCompleted: 5000)
        
        // Assert
        XCTAssertEqual(level.tasksCompleted, 5000)
        XCTAssertEqual(level.levelString, "Level 5")
        XCTAssertEqual(level.nextLevel, 10000)
    }
    
    func testLevel6() {
        // Arrange
        let level = Level(tasksCompleted: 10000)
        
        // Assert
        XCTAssertEqual(level.tasksCompleted, 10000)
        XCTAssertEqual(level.levelString, "Level 6")
        XCTAssertEqual(level.nextLevel, 100000)
    }
    
    func testLevelError() {
        // Arrange
        let level = Level.error(-50)
        
        // Assert
        XCTAssertEqual(level.tasksCompleted, -50)
        XCTAssertEqual(level.levelString, "ERROR")
        XCTAssertEqual(level.nextLevel, -404)
    }
}
