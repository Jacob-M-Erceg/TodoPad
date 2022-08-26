//
//  StatsControllerSortingOptionsTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-25.
//

import XCTest
@testable import TodoPad

class StatsControllerSortingOptionsTests: XCTestCase {
    
    func testStatsControllerSortingOptions_WhenInitializedWithoutAscending_IsAscendingTrue() {
        // Arrange
        let sortingOptions = StatsControllerSortingOptions(sortBy: .daysCompleted)
        
        // Assert
        XCTAssertTrue(sortingOptions.isAscending)
    }
    
    func testStatsControllerSortingOptions_IsAscendingSetter_ReturnsFalse() {
        // Arrange
        var sortingOptions = StatsControllerSortingOptions(sortBy: .daysCompleted)
        XCTAssertTrue(sortingOptions.isAscending)
        
        // Act
        sortingOptions.setIsAscending(with: false)
        
        // Assert
        XCTAssertFalse(sortingOptions.isAscending)
    }

    func testStatsControllerSortingOptions_SortBySetter_SortByName() {
        // Arrange
        var sortingOptions = StatsControllerSortingOptions(sortBy: .daysCompleted)
        XCTAssertEqual(sortingOptions.sortBy, .daysCompleted)
        
        // Act
        sortingOptions.setSortBy(with: .name)
        
        // Assert
        XCTAssertEqual(sortingOptions.sortBy, .name)
    }
}
