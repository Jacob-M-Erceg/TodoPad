//
//  MockTaskFormRepeatSettingsCellDelegate.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-09.
//

import Foundation
import XCTest
@testable import TodoPad

class MockTaskFormRepeatSettingsCellDelegate: TaskFormRepeatSettingsCellDelegate {
    
    var repeatSettings: RepeatSettings?
    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectRepeatSettings() {
        expectation = testCase.expectation(description: "Expect RepeatSettingsChanged Changed")
    }
    
    func didChangeRepeatSettings(_ repeatSettings: RepeatSettings) {
        self.repeatSettings = repeatSettings
        self.expectation?.fulfill()
    }
}
