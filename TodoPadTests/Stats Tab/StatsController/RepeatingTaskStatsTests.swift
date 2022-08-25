//
//  RepeatingTaskStatsTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-25.
//

import XCTest
@testable import TodoPad

class RepeatingTaskStatsTests: XCTestCase {

//    override func setUpWithError() throws {}
//    override func tearDownWithError() throws {}
    
    // MARK: - Days Since Started (Daily)
    func testDaysSinceStarted_WhenDailyAndToday_Returns1() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: .daily,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 1)
    }
    
    func testDaysSinceStarted_WhenDailyAndYesterday_Returns2() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24),
            time: nil,
            repeatSettings: .daily,
            endDate: nil,
            notificationsEnabled: false
        )
        
        devPrint(rTask.startDate)
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 2)
    }

    func testDaysSinceStarted_WhenDailyAndAWeekAgo_Returns7() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*7),
            time: nil,
            repeatSettings: .daily,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 8)
    }
    
    // MARK: - Days Since Started (Weekly)
    func testDaysSinceStarted_WhenWeeklyAndToday_Returns1() {
        // Arrange
        let todaysWeekday = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: .weekly([todaysWeekday]),
            endDate: nil,
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 1)
    }
    
    func testDaysSinceStarted_WhenWeeklyAndYesterday_Returns1() {
        // Arrange
        let todaysWeekday = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24),
            time: nil,
            repeatSettings: .weekly([todaysWeekday]),
            endDate: nil,
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 1)
    }
    
    func testDaysSinceStarted_WhenWeeklyAndAndAWeekAgo_Returns3() {
        // Arrange
        let todaysWeekday = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        var weekdays = [1, 5, 6]
        if weekdays.contains(where: { $0 == todaysWeekday }) { weekdays = [2, 3, 7] }
        
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*7),
            time: nil,
            repeatSettings: .weekly(weekdays),
            endDate: nil,
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 3)
    }
    
    
    // MARK: - Days Since Started (Monthly)
    func testDaysSinceStarted_WhenMonthlyAndYesterday_Returns1() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*2),
            time: nil,
            repeatSettings: .monthly,
            endDate: nil,
            notificationsEnabled: false
        )
        
        // Assert
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        XCTAssertEqual(rTaskStats.daysSinceStarted, 1)
    }
    
    func testDaysSinceStarted_WhenMonthlyAnd364DaysAgo_Returns12() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*364),
            time: nil,
            repeatSettings: .monthly,
            endDate: nil,
            notificationsEnabled: false
        )
        
        // Assert
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        XCTAssertEqual(rTaskStats.daysSinceStarted, 12)
    }
    
    func testDaysSinceStarted_WhenMonthlyAndOneYearAgo_Returns13() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*365),
            time: nil,
            repeatSettings: .monthly,
            endDate: nil,
            notificationsEnabled: false
        )
        
        // Assert
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        XCTAssertEqual(rTaskStats.daysSinceStarted, 13)
    }
    
    
    // MARK: - Days Since Started (Yearly)
    func testDaysSinceStarted_WhenYearlyAndYesterday_Returns1() {
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24),
            time: nil,
            repeatSettings: .yearly,
            endDate: nil,
            notificationsEnabled: false
        )
        
        // Assert
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        XCTAssertEqual(rTaskStats.daysSinceStarted, 1)
    }
    
    func testDaysSinceStarted_WhenYearlyAndOneYearAgo_Returns2() {
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*365),
            time: nil,
            repeatSettings: .yearly,
            endDate: nil,
            notificationsEnabled: false
        )
        
        // Assert
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        XCTAssertEqual(rTaskStats.daysSinceStarted, 2)
    }
    
    func testDaysSinceStarted_WhenYearlyAnd2YearsAgo_Returns3() {
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*365*2),
            time: nil,
            repeatSettings: .yearly,
            endDate: nil,
            notificationsEnabled: false
        )
        
        // Assert
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        XCTAssertEqual(rTaskStats.daysSinceStarted, 3)
    }
    
    
    // MARK: - Days Since Started (With EndDate)
    func testDaysSinceStarted_WhenDaily7DaysAgoEndDate3DaysAgo_4Days() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*7),
            time: nil,
            repeatSettings: .daily,
            endDate: Date().addingTimeInterval(-60*60*24*3),
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 4)
    }
    
    func testDaysSinceStarted_WhenWeeklyWithEndDate_11Days() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-60*60*24*14),
            time: nil,
            repeatSettings: .weekly([1, 2, 3, 4, 5, 6, 7]),
            endDate: Date().addingTimeInterval(-60*60*24*3),
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 11)
    }
    
    func testDaysSinceStarted_WhenMonthlyWithEndDate_2() {
        // Arrange
        let startDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: startDate,
            time: nil,
            repeatSettings: .monthly,
            endDate: Date().addingTimeInterval(-60*60*24*3),
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 2)
    }
    
    func testDaysSinceStarted_WhenYearlyWithEndDate_2() {
        // Arrange
        let startDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        
        let rTask = RepeatingTask(
            title: "My Repeating Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: startDate,
            time: nil,
            repeatSettings: .yearly,
            endDate: Date().addingTimeInterval(-60*60*24*3),
            notificationsEnabled: false
        )
        
        let rTaskStats = RepeatingTaskStats(repeatingTask: rTask, daysCompleted: 0)
        
        // Assert
        XCTAssertEqual(rTaskStats.daysSinceStarted, 2)
    }
}


