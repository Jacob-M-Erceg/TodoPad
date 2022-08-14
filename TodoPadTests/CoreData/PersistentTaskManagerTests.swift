//
//  PersistentTaskManagerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-12.
//

import XCTest
@testable import TodoPad

class PersistentTaskManagerTests: XCTestCase {
    
    var coreDataTestStack: CoreDataTestStack!
    var sut: PersistentTaskManager!
    
    let pTask = PersistentTask(title: "Finish App", desc: "Complete iOS App", taskUUID: UUID(), dateCompleted: Date())

    override func setUpWithError() throws {
        coreDataTestStack = CoreDataTestStack()
        sut = PersistentTaskManager(context: coreDataTestStack.context)
    }

    override func tearDownWithError() throws {
        coreDataTestStack = nil
        sut = nil
    }
}

// MARK: - Create
extension PersistentTaskManagerTests {
    
    func testPersistentTaskManager_CreateTask_SavesCorrectly() {
        // Act
        let pTaskCD = sut.saveNewPersistentTask(with: self.pTask)
        
        // Assert
        XCTAssertEqual(pTaskCD.title, self.pTask.title)
        XCTAssertEqual(pTaskCD.desc, self.pTask.desc)
        XCTAssertEqual(pTaskCD.taskUUID, self.pTask.taskUUID)
        XCTAssertEqual(pTaskCD.dateCompleted, self.pTask.dateCompleted)
    }
}


// MARK: - Read
extension PersistentTaskManagerTests {
    
    func testPersistentTaskManager_FetchTasks_ReturnsTwoTasks() {
        // Arrange
        let pTaskOne = self.pTask
        let pTaskTwo = PersistentTask(title: "My Task", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        
        self.sut.saveNewPersistentTask(with: pTaskOne)
        self.sut.saveNewPersistentTask(with: pTaskTwo)
        
        // Act
        let fetchedTasks = self.sut.fetchPersistentTasks()
        
        // Assert
        XCTAssertEqual(fetchedTasks.count, 2)
        
        let pTaskCDOne = fetchedTasks.first(where: { $0.taskUUID == pTaskOne.taskUUID })
        let pTaskCDTwo = fetchedTasks.first(where: { $0.taskUUID == pTaskTwo.taskUUID })
        
        XCTAssertEqual(pTaskOne.title, pTaskCDOne?.title)
        XCTAssertEqual(pTaskOne.desc, pTaskCDOne?.desc)
        XCTAssertEqual(pTaskOne.dateCompleted, pTaskCDOne?.dateCompleted)
        
        XCTAssertEqual(pTaskTwo.title, pTaskCDTwo?.title)
        XCTAssertEqual(pTaskTwo.desc, pTaskCDTwo?.desc)
        XCTAssertEqual(pTaskTwo.dateCompleted, pTaskCDTwo?.dateCompleted)
    }
    
    func testPersistentTaskManager_FetchCompletedTaskCount_ReturnsTwo() {
        // Arrange
        let pTaskOne = self.pTask
        let pTaskTwo = PersistentTask(title: "My Task", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        let pTaskThree = PersistentTask(title: "Take out garbage", desc: nil, taskUUID: UUID(), dateCompleted: Date().addingTimeInterval(60*60*24*(-3)))
        
        self.sut.saveNewPersistentTask(with: pTaskOne)
        self.sut.saveNewPersistentTask(with: pTaskTwo)
        self.sut.saveNewPersistentTask(with: pTaskThree)
        
        // Act
        let completedTaskCount = self.sut.fetchCompletedPersistentTaskCount()
        
        // Assert
        XCTAssertEqual(completedTaskCount, 2)
    }
    
}


// MARK: - Update
extension PersistentTaskManagerTests {

    func testPersistentTaskManager_UpdateTask() {
        // Arrange
        let pTask = PersistentTask(
            title: "My Task",
            desc: "Its a description!",
            taskUUID: UUID(),
            dateCompleted: Date().addingTimeInterval(60*60*24*(-3))
        )
        
        let pTaskCD = self.sut.saveNewPersistentTask(with: pTask)
        
        // Act
        let pTaskUpdate = PersistentTask(
            title: pTaskCD.title + " Updated Title",
            desc: pTaskCD.desc ?? "" + "Updated Desc",
            taskUUID: pTaskCD.taskUUID,
            dateCompleted: nil
        )
        
        self.sut.updatePersistentTask(with: pTaskUpdate)
        
        let pTaskUpdatedFetched = self.sut.fetchPersistentTasks().first
        
        // Assert
        XCTAssertEqual(pTask.title + " Updated Title", pTaskUpdatedFetched?.title)
        XCTAssertEqual(pTask.desc ?? ""  + "Updated Desc", pTaskUpdatedFetched?.desc)
        XCTAssertEqual(pTask.taskUUID, pTaskUpdatedFetched?.taskUUID)
        XCTAssertNotEqual(pTask.dateCompleted, pTaskUpdatedFetched?.dateCompleted)
        XCTAssertNil(pTaskUpdatedFetched?.dateCompleted)
    }
    
    
    func testPersistentTaskManager_InvertTaskCompleted_TaskReturnsNotCompleted() {
        // Arrange
        self.sut.saveNewPersistentTask(with: self.pTask) // pTask Initially Completed
        
        // Act
        self.sut.invertTaskCompleted(self.pTask, for: Date().addingTimeInterval(60*60*24*3))
        
        guard let pTaskFetched = self.sut.fetchPersistentTasks().first else { XCTFail(); return }
        
        // Assert
        XCTAssertFalse(pTaskFetched.isCompleted)
        XCTAssertNotEqual(pTask.isCompleted, pTaskFetched.isCompleted)
        XCTAssertNil(pTaskFetched.dateCompleted)
        XCTAssertNotEqual(pTask.dateCompleted, pTaskFetched.dateCompleted)
    }
    
    func testPersistentTaskManager_InvertTaskCompletedTwice_TaskReturnsCompleted() {
        // Arrange
        self.sut.saveNewPersistentTask(with: self.pTask) // pTask Initially Completed
        
        // Act
        self.sut.invertTaskCompleted(self.pTask, for: self.pTask.dateCompleted ?? Date())
        self.sut.invertTaskCompleted(self.pTask, for: self.pTask.dateCompleted ?? Date())
        
        guard let pTaskFetched = self.sut.fetchPersistentTasks().first else { XCTFail(); return }
        
        // Assert
        XCTAssertTrue(pTaskFetched.isCompleted)
        XCTAssertEqual(pTask.isCompleted, pTaskFetched.isCompleted)
        XCTAssertNotNil(pTaskFetched.dateCompleted)
        XCTAssertEqual(pTask.dateCompleted, pTaskFetched.dateCompleted)
    }
}


// MARK: - Delete
extension PersistentTaskManagerTests {
    
    func testPersistentTaskManager_DeleteTask() {
        // Arrange
        let pTaskOne = self.pTask
        let pTaskTwo = PersistentTask(title: "My Task", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        
        self.sut.saveNewPersistentTask(with: pTaskOne)
        self.sut.saveNewPersistentTask(with: pTaskTwo)
        
        let originalFetch = self.sut.fetchPersistentTasks()

        XCTAssertEqual(originalFetch.count, 2)
        
        // Act
        self.sut.deletePersistentTask(with: pTaskOne)
        let afterDeleteFetch = self.sut.fetchPersistentTasks()
        
        // Assert
        XCTAssertNotEqual(originalFetch.count, afterDeleteFetch.count)
        XCTAssertEqual(afterDeleteFetch.count, 1)
        
        let containsPTaskOne = afterDeleteFetch.contains(where: { $0.taskUUID == pTaskOne.taskUUID })
        XCTAssertFalse(containsPTaskOne)
    }

}
