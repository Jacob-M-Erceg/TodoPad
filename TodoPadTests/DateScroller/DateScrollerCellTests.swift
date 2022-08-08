//
//  DateScrollerCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-02.
//

import XCTest
@testable import TodoPad

class DateScrollerCellTests: XCTestCase {
    
    var sut: DateScrollerCell!

    override func setUpWithError() throws {
        sut = DateScrollerCell()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testDateScrollerCell_WhenDateIsTodayAndIsSelected_TextIsWhiteAndBackgroundIsBlue() {
        // Arrange
        sut.configure(with: Date())
        sut.setSelection(with: Date())
        
        // Assert
        XCTAssertEqual(sut.dayLabel.textColor.cgColor, UIColor.white.cgColor)
        XCTAssertEqual(sut.backgroundColor?.cgColor, UIColor.systemBlue.cgColor)
    }
    
    func testDateScrollerCell_WhenDateIsTodayAndIsNotSelected_TextIsBlueAndBackgroundIsDynamicColorOne() {
        // Arrange
        sut.configure(with: Date())
        sut.setSelection(with: Date().addingTimeInterval(24*60*60*3))
        
        // Assert
        XCTAssertEqual(sut.dayLabel.textColor.cgColor, UIColor.systemBlue.cgColor)
        XCTAssertEqual(sut.backgroundColor?.cgColor, UIColor.dynamicColorOne.cgColor)
    }
    
    func testDateScrollerCell_WhenDateIsNotTodayAndIsSelected_TextIsWhiteAndBackgroundIsBlue() {
        // Arrange
        sut.configure(with: Date().addingTimeInterval(24*60*60*3))
        sut.setSelection(with: Date().addingTimeInterval(24*60*60*3))
        
        // Assert
        XCTAssertEqual(sut.dayLabel.textColor.cgColor, UIColor.white.cgColor)
        XCTAssertEqual(sut.backgroundColor?.cgColor, UIColor.systemBlue.cgColor)
    }
    
    func testDateScrollerCell_WhenDateIsNotTodayAndIsNotSelected_TextIsLabelAndBackgroundIsDynamicColorOne() {
        // Arrange
        sut.configure(with: Date().addingTimeInterval(24*60*60*3))
        sut.setSelection(with: Date())
        
        // Assert
        XCTAssertEqual(sut.dayLabel.textColor.cgColor, UIColor.label.cgColor)
        XCTAssertEqual(sut.backgroundColor?.cgColor, UIColor.dynamicColorOne.cgColor)
    }

}
