//
//  MockDateScrollerDelegate.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-03.
//

import XCTest
@testable import TodoPad

class MockDateScrollerDelegate: DateScrollerDelegate {
    
    var newDate: Date?
    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectDate() {
        expectation = testCase.expectation(description: "Expect New Date")
    }
    
    func didChangeDate(with date: Date) {
        self.newDate = date
        expectation?.fulfill()
    }
}
