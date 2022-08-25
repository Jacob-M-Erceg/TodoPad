//
//  TaskTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-05.
//

import XCTest
@testable import TodoPad

class TaskTests: XCTestCase {

    // TODO - test or remove
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testTaskModel_WhenInitalized() {
        // Arrange
        let persistentTask = Task.persistent(PersistentTask(title: "Workout", desc: nil, taskUUID: UUID(), dateCompleted: nil))
        
        // Assert
    }
    
    
    

}
