//
//  MockTaskFormTextFieldCellDelegate.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-08.
//

import Foundation
import XCTest
@testable import TodoPad

class MockTaskFormTextFieldCellDelegate: TaskFormTextFieldCellDelegate {
    
    var string: String?
    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectString() {
        expectation = testCase.expectation(description: "Expect String Changed")
    }
    
    func didEditTextField(_ taskFormCellModel: TaskFormCellModel, _ text: String?) {
        self.string = text
        expectation?.fulfill()
    }
}
