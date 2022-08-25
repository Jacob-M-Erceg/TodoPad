//
//  StatsTableViewHeaderTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-25.
//

import XCTest
@testable import TodoPad

class StatsTableViewHeaderTests: XCTestCase {
    
    var sut: StatsTableViewHeader!

    override func setUpWithError() throws {
        self.sut = StatsTableViewHeader()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testStatsTableViewHeader_WhenConfigured_LevelStringIsLevel2() {
        // Arrange
        let level2 = Level(tasksCompleted: 100)
        
        // Act
        self.sut.configure(level: level2)
        
        // Assert
        XCTAssertEqual(self.sut.levelLabel.text, level2.levelString)
    }
    
    func testStatsTableViewHeader_WhenConfigured_TaskCompletedLevelIs337() {
        // Arrange
        let level = Level(tasksCompleted: 337)
        
        // Act
        self.sut.configure(level: level)
        
        // Assert
        let tasksCompletedString = "\(level.tasksCompleted)/\(level.nextLevel)\nTasks Completed"
        XCTAssertEqual(self.sut.tasksCompletedLabel.text, tasksCompletedString)
    }
    
    func testStatsTableViewHeader_WhenConfigured_ProgressBarIs_0_point_68() {
        // Arrange
        let level = Level(tasksCompleted: 34)
        
        // Act
        self.sut.configure(level: level)
        
        // Assert
        let lvlRatio = CGFloat(level.tasksCompleted)/CGFloat(level.nextLevel)
        XCTAssertEqual(self.sut.shapeLayer.strokeEnd, lvlRatio)
    }

}
