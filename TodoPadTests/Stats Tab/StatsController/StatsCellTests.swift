//
//  StatsCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-26.
//

import XCTest
@testable import TodoPad

class StatsCellTests: XCTestCase {
    
    var sut: StatsCell!

    override func setUpWithError() throws {
        self.sut = StatsCell()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testStatsCell_WhenConfigured_TaskTitleLabelSet() {
        // Arrange
        let rTask = RepeatingTask.getMockRepeatingTask
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 10)
        
        // Act
        self.sut.configure(repeatingTaskStats: rTaskStats)
        
        // Assert
        XCTAssertEqual(self.sut.taskTitleLabel.text, rTask.title)
    }

    func testStatsCell_WhenConfigured_TasksCompletedLabelSet() {
        // Arrange
        let rTask = RepeatingTask.getMockRepeatingTask
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 10)
        
        // Act
        self.sut.configure(repeatingTaskStats: rTaskStats)
        
        // Assert
        let tasksCompletedLabel = "\(rTaskStats.daysCompleted)/\(rTaskStats.daysSinceStarted) Days Completed"
        XCTAssertEqual(self.sut.tasksCompletedLabel.text, tasksCompletedLabel)
    }
    
    func testStatsCell_WhenConfigured_ProgressBarProgressSet() {
        // Arrange
        let rTask = RepeatingTask.getMockRepeatingTask
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 10)
        
        // Act
        self.sut.configure(repeatingTaskStats: rTaskStats)
        
        // Assert
        let progress = Float(rTaskStats.daysCompleted)/Float(rTaskStats.daysSinceStarted)
        XCTAssertEqual(self.sut.progressBar.progress, progress)
    }
    
    func testStatsCell_WhenConfigured_ProgressBarLabelSet() {
        // Arrange
        let rTask = RepeatingTask.getMockRepeatingTask
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 10)
        
        // Act
        self.sut.configure(repeatingTaskStats: rTaskStats)
        
        // Assert
        let percentageLabel = ((Double(rTaskStats.daysCompleted)/Double(rTaskStats.daysSinceStarted)*100)).roundTo(decimalPlaces: 1) + "%"
        XCTAssertEqual(self.sut.progressBar.label.text, percentageLabel)
    }
    
    func testStatsCell_WhenConfiguredWithTaskThatIsInFuture_ProgressBarProgressIsZero() {
        // Arrange
        let rTask = RepeatingTask(title: "rTask", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24*2), time: nil, repeatSettings: .daily, endDate: nil, notificationsEnabled: false)
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Act
        self.sut.configure(repeatingTaskStats: rTaskStats)
        
        // Assert
        XCTAssertEqual(self.sut.progressBar.progress, 0)
    }
    
    func testStatsCell_WhenConfiguredWithTaskThatIsInFuture_ProgressBarLabelIs0Percent() {
        // Arrange
        let rTask = RepeatingTask(title: "rTask", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24*2), time: nil, repeatSettings: .daily, endDate: nil, notificationsEnabled: false)
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Act
        self.sut.configure(repeatingTaskStats: rTaskStats)
        
        // Assert
        XCTAssertEqual(self.sut.progressBar.label.text, "0%")
    }
}
