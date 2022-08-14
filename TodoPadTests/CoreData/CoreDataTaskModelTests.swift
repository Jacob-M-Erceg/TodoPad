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


// MARK: - RepeatingTask
extension CoreDataTaskModelTests {

    func testRepeatingTaskCDModel_Initialize_NoNilVariables() {
        let rTask = RepeatingTask(
            title: "My Rep Task",
            desc: "A desctipton!",
            taskUUID: UUID(),
            isCompleted: true,
            startDate: Date(),
            time: Date().endOfDay,
            repeatSettings: .daily,
            endDate: Date().addingTimeInterval(60*60*24*3),
            notificationsEnabled: true
        )
        
        let rTaskCD = RepeatingTaskCD(self.context, rTask)
        
        XCTAssertEqual(rTask.title, rTaskCD.title)
        XCTAssertEqual(rTask.desc, rTaskCD.desc)
        XCTAssertEqual(rTask.taskUUID, rTaskCD.taskUUID)
        XCTAssertEqual(rTask.startDate.startOfDay, rTaskCD.startDate)
        XCTAssertEqual(rTask.time, rTaskCD.time)
        XCTAssertEqual(rTask.repeatSettings.number, Int(rTaskCD.repeatSettings.peroid))
        XCTAssertEqual(rTask.endDate, rTaskCD.endDate)
        XCTAssertEqual(rTask.notificationsEnabled, rTaskCD.notificationsEnabled)
        
        XCTAssertNotNil(rTaskCD.desc)
        XCTAssertNotNil(rTaskCD.time)
        XCTAssertNotNil(rTaskCD.endDate)
    }
    
    func testRepeatingTaskCDModel_Initialize_WithNilVariables() {
        let rTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: .yearly,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let rTaskCD = RepeatingTaskCD(self.context, rTask)
        
        XCTAssertEqual(rTask.title, rTaskCD.title)
        XCTAssertEqual(rTask.desc, rTaskCD.desc)
        XCTAssertEqual(rTask.taskUUID, rTaskCD.taskUUID)
        XCTAssertEqual(rTask.startDate.startOfDay, rTaskCD.startDate)
        XCTAssertEqual(rTask.time, rTaskCD.time)
        XCTAssertEqual(rTask.repeatSettings.number, Int(rTaskCD.repeatSettings.peroid))
        XCTAssertEqual(rTask.endDate, rTaskCD.endDate)
        XCTAssertEqual(rTask.notificationsEnabled, rTaskCD.notificationsEnabled)
        
        XCTAssertNil(rTaskCD.desc)
        XCTAssertNil(rTaskCD.time)
        XCTAssertNil(rTaskCD.endDate)
    }
    
    // MARK: - CompletedRepeatingTaskCD (RepeatingTask)
    func testCompletedRepeatingTaskCD_Initialize() {
        // Arrange
        let rTaskUUID = UUID()
        let dateCompleted = Date()
        
        let cRTask = CompletedRepeatingTaskCD(context: self.context)
        cRTask.taskUUID = rTaskUUID
        cRTask.dateCompleted = dateCompleted
        
        // Assert
        XCTAssertEqual(cRTask.taskUUID, rTaskUUID)
        XCTAssertEqual(cRTask.dateCompleted, dateCompleted)
    }
    
    
    // MARK: - RepeatSettings (RepeatingTask)
    func testRepeatSettings_InitializeDaily_DaysEmptyPeroidZero() {
        // Arrange
        let repeatSettings = RepeatSettings.daily
        
        let repeatTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: repeatSettings,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let repeatTaskCD = RepeatingTaskCD(self.context, repeatTask)
        
        // Act
        let repeatSettingsCD = RepeatSettingsCD(self.context, repeatSettings, repeatTaskCD)
        
        // Assert
        XCTAssertEqual(repeatSettingsCD.days, [])
        XCTAssertEqual(repeatSettingsCD.peroid, 0)
    }
    
    func testRepeatSettings_InitializeWeekly_DaysArrayCorrectPeroidOne() {
        // Arrange
        let repeatSettings = RepeatSettings.weekly([1, 5, 6])
        
        let repeatTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: repeatSettings,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let repeatTaskCD = RepeatingTaskCD(self.context, repeatTask)
        
        // Act
        let repeatSettingsCD = RepeatSettingsCD(self.context, repeatSettings, repeatTaskCD)
        
        // Assert
        XCTAssertEqual(repeatSettingsCD.days, [1, 5, 6])
        XCTAssertEqual(repeatSettingsCD.peroid, 1)
    }
    
    func testRepeatSettings_InitializeMonthly_DaysEmptyPeroidTwo() {
        // Arrange
        let repeatSettings = RepeatSettings.monthly
        
        let repeatTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: repeatSettings,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let repeatTaskCD = RepeatingTaskCD(self.context, repeatTask)
        
        // Act
        let repeatSettingsCD = RepeatSettingsCD(self.context, repeatSettings, repeatTaskCD)
        
        // Assert
        XCTAssertEqual(repeatSettingsCD.days, [])
        XCTAssertEqual(repeatSettingsCD.peroid, 2)
    }
    
    func testRepeatSettings_InitializeYearly_DaysEmptyPeroidThree() {
        // Arrange
        let repeatSettings = RepeatSettings.yearly
        
        let repeatTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: repeatSettings,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let repeatTaskCD = RepeatingTaskCD(self.context, repeatTask)
        
        // Act
        let repeatSettingsCD = RepeatSettingsCD(self.context, repeatSettings, repeatTaskCD)
        
        // Assert
        XCTAssertEqual(repeatSettingsCD.days, [])
        XCTAssertEqual(repeatSettingsCD.peroid, 3)
    }
    
    func testRepeatSettings_UpdateRepeatSettigns() {
        // Arrange
        let repeatSettings = RepeatSettings.daily
        
        let repeatTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: repeatSettings,
            endDate: nil,
            notificationsEnabled: false
        )
        
        let repeatTaskCD = RepeatingTaskCD(self.context, repeatTask)
        
        // Act
        let repeatSettingsCD = RepeatSettingsCD(self.context, repeatSettings, repeatTaskCD)
        XCTAssertEqual(repeatSettingsCD.days, [])
        XCTAssertEqual(repeatSettingsCD.peroid, 0)
        
        repeatSettingsCD.update(.weekly([1, 2, 3]))
        XCTAssertEqual(repeatSettingsCD.days, [1, 2, 3])
        XCTAssertEqual(repeatSettingsCD.peroid, 1)
        
        repeatSettingsCD.update(.monthly)
        XCTAssertEqual(repeatSettingsCD.days, [])
        XCTAssertEqual(repeatSettingsCD.peroid, 2)
        
        repeatSettingsCD.update(.yearly)
        XCTAssertEqual(repeatSettingsCD.days, [])
        XCTAssertEqual(repeatSettingsCD.peroid, 3)
        
        repeatSettingsCD.update(.daily)
        XCTAssertEqual(repeatSettingsCD.days, [])
        XCTAssertEqual(repeatSettingsCD.peroid, 0)
        // Assert
        
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
