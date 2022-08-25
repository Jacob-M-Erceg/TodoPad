//
//  MockBaseTaskFormDropDownCellDelegate.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-08.
//

import Foundation
import XCTest
@testable import TodoPad

class MockBaseTaskFormDropDownCellDelegate: BaseTaskFormDropDownCellDelegate {
    
    var isEnabled: Bool?
    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectIsEnabledBoolean() {
        expectation = testCase.expectation(description: "Expect didChangeCellIsEnabled Called")
    }
    
    func didChangeCellIsEnabled(taskFormCellModel: TaskFormCellModel, isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.expectation?.fulfill()
    }
}
