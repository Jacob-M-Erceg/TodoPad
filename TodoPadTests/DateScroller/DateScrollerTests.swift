//
//  DateScrollerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-02.
//

import XCTest
@testable import TodoPad

class DateScrollerTests: XCTestCase {
    
    var sut: DateScroller!

    override func setUpWithError() throws {
        sut = DateScroller()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testDateScroller_WhenLoaded_CollectionViewHasSevenCells() {
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 7)
    }
    
    func testDateScroller_WhenDayCellTapped_SelectedDateChanged() {
        // Arrange
        let originalDate = sut.viewModel.selectedDate
        
        // Make sure we don't select the current day.
        let row = DateHelper.getWeekdayNumber(for: Date())-1 == 0 ? 1 : 0
        let indexPath = IndexPath(row: row, section: 0)
        
        // Act
        sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: indexPath)
        
        // Assert
        XCTAssertNotEqual(originalDate, sut.viewModel.selectedDate)
    }
    
    func testDateScroller_WhenDayCellIsTapped_DelegateIsCalled() throws {
        // Arrange
        let mockDelegate = MockDateScrollerDelegate(testCase: self)
        sut.delegate = mockDelegate
        
        let originalDate = sut.viewModel.selectedDate
        
        let row = DateHelper.getWeekdayNumber(for: Date())-1 == 0 ? 1 : 0
        let indexPath = IndexPath(row: row, section: 0)
        
        
        // Act
        mockDelegate.expectDate()
        sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: indexPath)
        
        // Asssert
        waitForExpectations(timeout: 1)
        
        let newDate = try XCTUnwrap(mockDelegate.newDate)
        XCTAssertNotEqual(originalDate, newDate)
    }
    
    func testDateScroller_didLeftSwipeSelector_newSundayIsLessThan() {
        // Arrange
        let originalSunday = sut.viewModel.currentSunday
        
        // Act
        sut.didLeftSwipe()
        
        // Assert
        XCTAssertLessThan(originalSunday, sut.viewModel.currentSunday)
    }
    
    func testDateScroller_didRightSwipe_newSundayIsGreaterThan() {
        // Arrange
        let originalSunday = sut.viewModel.currentSunday
        
        // Act
        sut.didRightSwipe()
        
        // Assert
        XCTAssertGreaterThan(originalSunday, sut.viewModel.currentSunday)
    }

}
