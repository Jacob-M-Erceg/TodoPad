//
//  DateScrollerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-02.
//

import XCTest
@testable import TodoPad

class DateScrollerViewModelTests: XCTestCase {
    
    var sut: DateScrollerViewModel!

    override func setUpWithError() throws {
        sut = DateScrollerViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testDateScrollerViewModel_WhenLoaded_CurrentSundayIsSet() {
        // Arrange
        let today = Date()
        let currentSunday = DateHelper.getSunday(for: today)
        
        // Assert
        XCTAssertEqual(
            currentSunday.timeIntervalSince1970,
            sut.currentSunday.timeIntervalSince1970,
            accuracy: 0.1,
            "The sundays did not match in the DateScrollerViewModelTests WhenLoaded test."
        )
    }
    
    func testDateScrollerViewModel_WhenLeftSwipe_NextSundayIsSet() {
        // Arrange
        let today = Date()
        var currentSunday = DateHelper.getSunday(for: today)
        let newDate = DateHelper.addDays(currentSunday, offset: 7)
        currentSunday = DateHelper.getSunday(for: newDate)
        
        // Act
        sut.updateSunday(direction: .left)
        
        // Assert
        XCTAssertEqual(
            currentSunday.timeIntervalSince1970,
            sut.currentSunday.timeIntervalSince1970,
            accuracy: 0.1,
            "The sundays did not match in the DateScrollerViewModelTests WhenLeftSwipe test."
        )
    }
    
    func testDateScrollerViewModel_WhenSetSelectedDateCalled_SelectedDateChanged() {
        // Arrange
        let originalDate = sut.selectedDate
        
        // Act
        sut.setSelectedDate(with: Date().addingTimeInterval(24*60*60*365*10))
        
        // Assert
        XCTAssertNotEqual(originalDate, sut.selectedDate)
    }
    

}
