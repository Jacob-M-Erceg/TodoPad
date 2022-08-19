//
//  MockTasksControllerDelegate.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-18.
//

import XCTest
@testable import TodoPad

class MockTasksControllerDelegate: TasksControllerDelegate {
    
    
    
    func showTasksCompletedPopup() {
        // TODO - 
    }
}

/*
 class MockTasksTableViewHeaderDelegate: TasksTableViewHeaderDelegate {
     
     var wasCalled: Bool = false
     private var expectation: XCTestExpectation?
     private let testCase: XCTestCase
     
     init(testCase: XCTestCase) {
         self.testCase = testCase
     }
     
     func expect() {
         expectation = testCase.expectation(description: "Expect didTapAddNewTask")
     }
     
     func didTapAddNewTask() {
         self.wasCalled = true
         expectation?.fulfill()
     }
 }

 */
