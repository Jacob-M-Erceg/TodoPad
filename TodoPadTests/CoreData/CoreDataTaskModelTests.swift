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
        
        XCTAssertNotNil(pTaskCD.desc)
        XCTAssertNotNil(pTaskCD.dateCompleted)
    }
    
    func testPersistenTaskCDModel_Initialize_WithNilVariables() {
        // Arrange
        let pTask = PersistentTask(title: "PTaskTitle", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        
        // Act
        let pTaskCD = PersistentTaskCD.init(self.context, pTask)
        
        // Assert
        XCTAssertEqual(pTaskCD.title, pTask.title)
        XCTAssertEqual(pTaskCD.desc, pTask.desc)
        XCTAssertEqual(pTaskCD.taskUUID, pTask.taskUUID)
        XCTAssertEqual(pTaskCD.dateCompleted, pTask.dateCompleted)
        
        XCTAssertNil(pTaskCD.desc)
        XCTAssertNil(pTaskCD.dateCompleted)
    }
}


// MARK: - Non-RepeatingTask
extension CoreDataTaskModelTests {
    
    func testNonRepeatingTaskCDModel_Initialize_NoNilVariables() {
        // Arrange
        let nonRepTask = NonRepeatingTask(
            title: "My Non-Rep Task",
            desc: "A Non-Rep Task desc",
            taskUUID: UUID(),
            isCompleted: false,
            date: Date(),
            time: Date().endOfDay,
            notificationsEnabled: true
        )
        
        // Act
        let nonRepTaskCD = NonRepeatingTaskCD(self.context, nonRepTask)
        
        // Assert
        XCTAssertEqual(nonRepTask.title, nonRepTaskCD.title)
        XCTAssertEqual(nonRepTask.desc, nonRepTaskCD.desc)
        XCTAssertEqual(nonRepTask.taskUUID, nonRepTaskCD.taskUUID)
        XCTAssertEqual(nonRepTask.isCompleted, nonRepTaskCD.isCompleted)
        XCTAssertEqual(nonRepTask.date, nonRepTaskCD.date)
        XCTAssertEqual(nonRepTask.time, nonRepTaskCD.time)
        XCTAssertEqual(nonRepTask.notificationsEnabled, nonRepTaskCD.notificationsEnabled)
        
        XCTAssertNotNil(nonRepTaskCD.desc)
        XCTAssertNotNil(nonRepTaskCD.time)
    }
    
    func testNonRepeatingTaskCDModel_Initialize_WithNilVariables() {
        // Arrange
        let nonRepTask = NonRepeatingTask(
            title: "My Non-Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: true,
            date: Date(),
            time: nil,
            notificationsEnabled: false
        )
        
        // Act
        let nonRepTaskCD = NonRepeatingTaskCD(self.context, nonRepTask)
        
        // Assert
        XCTAssertEqual(nonRepTask.title, nonRepTaskCD.title)
        XCTAssertEqual(nonRepTask.desc, nonRepTaskCD.desc)
        XCTAssertEqual(nonRepTask.taskUUID, nonRepTaskCD.taskUUID)
        XCTAssertEqual(nonRepTask.isCompleted, nonRepTaskCD.isCompleted)
        XCTAssertEqual(nonRepTask.date, nonRepTaskCD.date)
        XCTAssertEqual(nonRepTask.time, nonRepTaskCD.time)
        XCTAssertEqual(nonRepTask.notificationsEnabled, nonRepTaskCD.notificationsEnabled)
        
        XCTAssertNil(nonRepTaskCD.desc)
        XCTAssertNil(nonRepTaskCD.time)
    }
}
