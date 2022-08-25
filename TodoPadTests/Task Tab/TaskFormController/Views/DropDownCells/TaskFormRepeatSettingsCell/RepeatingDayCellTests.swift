//
//  RepeatingDayCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-10.
//

import XCTest
@testable import TodoPad

class RepeatingDayCellTests: XCTestCase {
    
    func testRepeatingDayCell_WhenConfigured_DayLabelIsSet() {
        // Arrange
        let cell = RepeatingDayCell()
        cell.configure(with: "M", and: false)
        
        // Assert
        XCTAssertEqual(cell.label.text, "M")
    }
    
    func testRepeatingDayCell_WhenConfiguredForSelected_CorrectColorsSet() {
        // Arrange
        let cell = RepeatingDayCell()
        cell.configure(with: "M", and: true)
        
        // Assert
        XCTAssertEqual(cell.backgroundColor?.cgColor, UIColor.systemBlue.cgColor, "The cells background color should be .systemBlue when the cell is selected.")
        XCTAssertEqual(cell.label.textColor.cgColor, UIColor.white.cgColor, "The labels text color should be .white when the cell is selected.")
    }
    
    func testRepeatingDayCell_WhenConfiguredForNotSelected_CorrectColorsSet() {
        // Arrange
        let cell = RepeatingDayCell()
        cell.configure(with: "M", and: false)
        
        // Assert
        XCTAssertEqual(cell.backgroundColor?.cgColor, UIColor.clear.cgColor, "The cells background color should be .clear when the cell is not selected.")
        XCTAssertEqual(cell.label.textColor.cgColor, UIColor.label.cgColor, "The labels text color should be .label when the cell is not selected.")
    }
}
