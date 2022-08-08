//
//  RepeatSettingsTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-05.
//

import XCTest
@testable import TodoPad

class RepeatSettingsTests: XCTestCase {
    
    func testRepeatSettings_InitalizeRepeatSettingsNormally() {
        // Arrange
        let dailyRepeatSettings = RepeatSettings.daily
        let weeklyRepeatSettings = RepeatSettings.weekly([])
        let monthlyRepeatSettings = RepeatSettings.monthly
        let yearlyRepeatSettings = RepeatSettings.yearly
        
        // Assert
        XCTAssertNotNil(dailyRepeatSettings)
        XCTAssertNotNil(weeklyRepeatSettings)
        XCTAssertNotNil(monthlyRepeatSettings)
        XCTAssertNotNil(yearlyRepeatSettings)
    }
    
    func testRepeatSettings_InitalizeRepeatSettingsWithInteger() {
        // Arrange
        let dailyRepeatSettings = RepeatSettings(number: 0)
        let weeklyRepeatSettings = RepeatSettings(number: 1)
        let monthlyRepeatSettings = RepeatSettings(number: 2)
        let yearlyRepeatSettings = RepeatSettings(number: 3)
        
        // Assert
        XCTAssertEqual(dailyRepeatSettings.number, RepeatSettings.daily.number)
        XCTAssertEqual(weeklyRepeatSettings.number, RepeatSettings.weekly([]).number)
        XCTAssertEqual(monthlyRepeatSettings.number, RepeatSettings.monthly.number)
        XCTAssertEqual(yearlyRepeatSettings.number, RepeatSettings.yearly.number)
    }
    
    func testRepeatSettings_InitalizeRepeatSettingsWithNSInt() {
        // Arrange
        let dailyRepeatSettings = RepeatSettings(number: Int16(0), days: [])
        let weeklyRepeatSettings = RepeatSettings(number: Int16(1), days: [1, 2, 3])
        let monthlyRepeatSettings = RepeatSettings(number: Int16(2), days: [])
        let yearlyRepeatSettings = RepeatSettings(number: Int16(3), days: [])

        // Assert
        XCTAssertEqual(dailyRepeatSettings.number, RepeatSettings.daily.number)
        XCTAssertEqual(weeklyRepeatSettings.number, RepeatSettings.weekly([]).number)
        XCTAssertEqual(monthlyRepeatSettings.number, RepeatSettings.monthly.number)
        XCTAssertEqual(yearlyRepeatSettings.number, RepeatSettings.yearly.number)
    }
    
    func testRepeatSettings_NumberComputedPropertyIsCorrect() {
        // Assert
        XCTAssertEqual(RepeatSettings.daily.number, 0)
        XCTAssertEqual(RepeatSettings.weekly([]).number, 1)
        XCTAssertEqual(RepeatSettings.monthly.number, 2)
        XCTAssertEqual(RepeatSettings.yearly.number, 3)
    }
    
    func testRepeatSettings_RepeatPeriodStringIsCorrect() {
        // Assert
        XCTAssertEqual(RepeatSettings.daily.repeatPeroidString, "Repeats Daily")
        XCTAssertEqual(RepeatSettings.weekly([]).repeatPeroidString, "Repeats Weekly")
        XCTAssertEqual(RepeatSettings.monthly.repeatPeroidString, "Repeats Monthly")
        XCTAssertEqual(RepeatSettings.yearly.repeatPeroidString, "Repeats Yearly")
    }
    
    func testRepeatSettings_WhenRepeatSettingsIsNotWeekly_ReturnsNil() {
        // Arrange
        let dailyRepeatSettings = RepeatSettings.daily
        let monthlyRepeatSettings = RepeatSettings.monthly
        let yearlyRepeatSettings = RepeatSettings.yearly

        // Assert
        XCTAssertNil(dailyRepeatSettings.getWeeklyArray)
        XCTAssertNil(monthlyRepeatSettings.getWeeklyArray)
        XCTAssertNil(yearlyRepeatSettings.getWeeklyArray)
    }
    
    func testRepeatSettings_WhenRepeatSettingsIsNotWeekly_ReturnsWeekdayArray() {
        // Arrange
        let weeklyRepeatSettings = RepeatSettings.weekly([1, 4, 5])
        
        // Assert
        XCTAssertNotNil(weeklyRepeatSettings.getWeeklyArray)
    }

}
