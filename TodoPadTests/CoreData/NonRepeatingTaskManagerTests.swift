//
//  NonRepeatingTaskManagerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-13.
//

import XCTest
@testable import TodoPad

class NonRepeatingTaskManagerTests: XCTestCase {
    
    var coreDataTestStack: CoreDataTestStack!
    var sut: NonRepeatingTaskManager!
    
    let nonRepTask = NonRepeatingTask(
        title: "My Non-Rep Task",
        desc: "A Non-Rep Task desc",
        taskUUID: UUID(),
        isCompleted: true,
        date: Date(),
        time: Date().endOfDay,
        notificationsEnabled: true
    )
    
    
    override func setUpWithError() throws {
        coreDataTestStack = CoreDataTestStack()
        sut = NonRepeatingTaskManager(context: coreDataTestStack.context)
    }
    
    override func tearDownWithError() throws {
        coreDataTestStack = nil
        sut = nil
    }
}


// MARK: - Create
extension NonRepeatingTaskManagerTests {
    
    func testNonRepeatingTaskManager_CreateTask_SavesCorrectly() {
        // Act
        let nonRepTaskCD = self.sut.saveNewNonRepeatingTask(with: self.nonRepTask)
        
        // Assert
        XCTAssertEqual(nonRepTaskCD.title, self.nonRepTask.title)
        XCTAssertEqual(nonRepTaskCD.desc, self.nonRepTask.desc)
        XCTAssertEqual(nonRepTaskCD.taskUUID, self.nonRepTask.taskUUID)
        XCTAssertEqual(nonRepTaskCD.date, self.nonRepTask.date)
        XCTAssertEqual(nonRepTaskCD.time, self.nonRepTask.time)
        XCTAssertEqual(nonRepTaskCD.isCompleted, self.nonRepTask.isCompleted)
        XCTAssertEqual(nonRepTaskCD.notificationsEnabled, self.nonRepTask.notificationsEnabled)
    }
}


// MARK: - Read
extension NonRepeatingTaskManagerTests {
    
    func testNonRepeatingTaskManager_FetchTasksForToday_ReturnsOneTask() {
        // Arrange
        let nonRepTaskOne = self.nonRepTask
        let nonRepTaskTwo = NonRepeatingTask(title: "My second task", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date().addingTimeInterval(60*60*24), time: nil, notificationsEnabled: false)
        
        self.sut.saveNewNonRepeatingTask(with: nonRepTaskOne)
        self.sut.saveNewNonRepeatingTask(with: nonRepTaskTwo)
        
        // Act
        let fetchedTasks = self.sut.fetchNonRepeatingTasks(for: Date())
        let fetchedNonRepTaskOne = fetchedTasks.first
        
        // Assert
        XCTAssertEqual(fetchedTasks.count, 1)
        XCTAssertEqual(fetchedNonRepTaskOne?.title, nonRepTaskOne.title)
        XCTAssertEqual(fetchedNonRepTaskOne?.taskUUID, nonRepTaskOne.taskUUID)
    }
    
    func testNonRepeatingTaskManager_FetchTasksForTomorrow_ReturnsOneTask() {
        // Arrange
        let nonRepTaskOne = self.nonRepTask
        let nonRepTaskTwo = NonRepeatingTask(title: "My second task", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date().addingTimeInterval(60*60*24), time: nil, notificationsEnabled: false)
        
        self.sut.saveNewNonRepeatingTask(with: nonRepTaskOne)
        self.sut.saveNewNonRepeatingTask(with: nonRepTaskTwo)
        
        // Act
        let fetchedTasks = self.sut.fetchNonRepeatingTasks(for: Date().addingTimeInterval(60*60*24))
        let fetchedNonRepTaskTwo = fetchedTasks.first
        
        // Assert
        XCTAssertEqual(fetchedTasks.count, 1)
        XCTAssertEqual(fetchedNonRepTaskTwo?.title, nonRepTaskTwo.title)
        XCTAssertEqual(fetchedNonRepTaskTwo?.taskUUID, nonRepTaskTwo.taskUUID)
    }
    
    func testNonRepeatingTaskManager_FetchTasksForTomorrow_ReturnsNoTasks() {
        // Act
        let fetchedTasks = self.sut.fetchNonRepeatingTasks(for: Date().addingTimeInterval(60*60*24))
        
        // Assert
        XCTAssertEqual(fetchedTasks.count, 0)
    }
    
    func testNonRepeatingTaskManager_FetchCompletedTaskCount_ReturnsTwo() {
        // Arrange
        let nonRepTaskOne = self.nonRepTask
        let nonRepTaskTwo = NonRepeatingTask(title: "My second task", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date().addingTimeInterval(60*60*24), time: nil, notificationsEnabled: false)
        let nonRepTaskThree = NonRepeatingTask(title: "My third task", desc: "Another desc", taskUUID: UUID(), isCompleted: true, date: Date().addingTimeInterval(60*60*24*(-3)), time: nil, notificationsEnabled: true)
        
        self.sut.saveNewNonRepeatingTask(with: nonRepTaskOne)
        self.sut.saveNewNonRepeatingTask(with: nonRepTaskTwo)
        self.sut.saveNewNonRepeatingTask(with: nonRepTaskThree)
        
        // Act
        let completedTaskCount = self.sut.fetchCompletedNonRepeatingTaskCount()
        
        // Assert
        XCTAssertEqual(completedTaskCount, 2)
    }
    
}


// MARK: - Update
extension NonRepeatingTaskManagerTests {
    
    func testNonRepeatingTaskManager_UpdateTask() {
        // Arrange
        let nonRepTask = NonRepeatingTask(
            title: "My second task",
            desc: "Wow a task!",
            taskUUID: UUID(),
            isCompleted: false,
            date: Date().addingTimeInterval(60*60*24),
            time: Date().addingTimeInterval(60*60*3),
            notificationsEnabled: false
        )
        
        self.sut.saveNewNonRepeatingTask(with: nonRepTask)
        
        // Act
        let nonRepTaskUpdate = NonRepeatingTask(
            title: "My second task Updated",
            desc: "Wow a task! Updated",
            taskUUID: nonRepTask.taskUUID,
            isCompleted: true,
            date: Date(),
            time: Date(),
            notificationsEnabled: true
        )
        
        self.sut.updateNonRepeatingTask(with: nonRepTaskUpdate)
        
        let nonRepTaskFetched = self.sut.fetchNonRepeatingTasks(for: nonRepTask.taskUUID)
        
        XCTAssertEqual(nonRepTaskFetched?.title, nonRepTaskUpdate.title)
        XCTAssertEqual(nonRepTaskFetched?.desc, nonRepTaskUpdate.desc)
        XCTAssertEqual(nonRepTaskFetched?.taskUUID, nonRepTaskUpdate.taskUUID)
        XCTAssertEqual(nonRepTaskFetched?.isCompleted, nonRepTaskUpdate.isCompleted)
        XCTAssertEqual(nonRepTaskFetched?.date, nonRepTaskUpdate.date)
        XCTAssertEqual(nonRepTaskFetched?.time, nonRepTaskUpdate.time)
        XCTAssertEqual(nonRepTaskFetched?.notificationsEnabled, nonRepTaskUpdate.notificationsEnabled)
    }
    
    func testNonRepeatingTaskManager_InvertTaskCompleted_TaskReturnsNotCompleted() {
        // Arrange
        self.sut.saveNewNonRepeatingTask(with: self.nonRepTask) // Initially completed
        
        // Act
        self.sut.invertTaskCompleted(self.nonRepTask)
        let nonRepTasksFetched = self.sut.fetchNonRepeatingTasks(for: self.nonRepTask.taskUUID)
        
        // Assert
        XCTAssertEqual(nonRepTasksFetched?.isCompleted, false)
    }
    
    func testNonRepeatingTaskManager_InvertTaskCompletedTwice_TaskReturnsCompleted() {
        // Arrange
        self.sut.saveNewNonRepeatingTask(with: self.nonRepTask) // Initially completed
        
        // Act
        self.sut.invertTaskCompleted(self.nonRepTask)
        self.sut.invertTaskCompleted(self.nonRepTask)
        
        let nonRepTasksFetched = self.sut.fetchNonRepeatingTasks(for: self.nonRepTask.taskUUID)
        
        // Assert
        XCTAssertEqual(nonRepTasksFetched?.isCompleted, true)
    }
}


// MARK: - Delete
extension NonRepeatingTaskManagerTests {
    
    func testNonRepeatingTaskManager_DeleteTask() {
        // Arrange
        let nonRepTask = self.nonRepTask
        self.sut.saveNewNonRepeatingTask(with: nonRepTask)
        
        let originalFetch = self.sut.fetchNonRepeatingTasks(for: nonRepTask.date)
        
        XCTAssertEqual(originalFetch.count, 1)
        
        // Act
        self.sut.deleteNonRepeatingTask(for: nonRepTask)
        let afterDeleteFetch = self.sut.fetchNonRepeatingTasks(for: nonRepTask.date)
        
        // Assert
        XCTAssertNotEqual(originalFetch.count, afterDeleteFetch.count)
        XCTAssertEqual(afterDeleteFetch.count, 0)
    }
}
