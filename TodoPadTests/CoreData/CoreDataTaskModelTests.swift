//
//  CoreDataTaskModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-12.
//

import XCTest
import CoreData
@testable import TodoPad

class CoreDataTaskModelTests: XCTestCase {
    
    var coreDataTestStack: CoreDataTestStack!
    
    var context: NSManagedObjectContext {
        return coreDataTestStack.context
    }

    override func setUpWithError() throws {
        coreDataTestStack = CoreDataTestStack()
    }

    override func tearDownWithError() throws {
        coreDataTestStack = nil
    }
}


// MARK: - PersistentTask
extension CoreDataTaskModelTests {
    
    func testPersistenTaskCDModel_Initialize_NoNilVariables() {
        let pTask = PersistentTask(title: "PTaskTitle", desc: "myDesc", taskUUID: UUID(), dateCompleted: Date())
        let pTaskCD = PersistentTaskCD.init(self.context, pTask)
        
        XCTAssertEqual(pTaskCD.title, pTask.title)
        XCTAssertEqual(pTaskCD.desc, pTask.desc)
        XCTAssertEqual(pTaskCD.taskUUID, pTask.taskUUID)
        XCTAssertEqual(pTaskCD.dateCompleted, pTask.dateCompleted)
    }
    
    func testPersistenTaskCDModel_Initialize_WithNilVariables() {
        let pTask = PersistentTask(title: "PTaskTitle", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        let pTaskCD = PersistentTaskCD.init(self.context, pTask)
        
        XCTAssertEqual(pTaskCD.title, pTask.title)
        XCTAssertEqual(pTaskCD.desc, pTask.desc)
        XCTAssertEqual(pTaskCD.taskUUID, pTask.taskUUID)
        XCTAssertEqual(pTaskCD.dateCompleted, pTask.dateCompleted)
    }
}
