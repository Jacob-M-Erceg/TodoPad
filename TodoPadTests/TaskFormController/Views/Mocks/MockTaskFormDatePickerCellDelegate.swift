//
//  MockTaskFormDatePickerCellDelegate.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-09.
//

import Foundation
import XCTest
@testable import TodoPad

class MockTaskFormDatePickerCellDelegate: TaskFormDatePickerCellDelegate {
    
    var date: Date?
    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectDate() {
        expectation = testCase.expectation(description: "Expect Date Changed")
    }
    
    func didEditDatePicker(_ taskFormCellModel: TaskFormCellModel, _ date: Date) {
        self.date = date
        self.expectation?.fulfill()
    }
}
