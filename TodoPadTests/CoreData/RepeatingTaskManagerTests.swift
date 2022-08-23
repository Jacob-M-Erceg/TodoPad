//
//  RepeatingTaskManagerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-13.
//

import XCTest
@testable import TodoPad

class RepeatingTaskManagerTests: XCTestCase {
    
    var coreDataTestStack: CoreDataTestStack!
    var sut: RepeatingTaskManager!
    
    let rTask = RepeatingTask(
        title: "My repeating task",
        desc: "My description!",
        taskUUID: UUID(),
        isCompleted: false,
        startDate: Date(),
        time: Date().addingTimeInterval(60*60*3.5),
        repeatSettings: .weekly([1, 3, 5]),
        endDate: nil,
        notificationsEnabled: false
    )

    override func setUpWithError() throws {
        self.coreDataTestStack = CoreDataTestStack()
        self.sut = RepeatingTaskManager(context: self.coreDataTestStack.context)
    }

    override func tearDownWithError() throws {
        self.coreDataTestStack = nil
        self.sut = nil
    }
}


// MARK: - Create
extension RepeatingTaskManagerTests {
    
    func testRepeatingTaskManager_CreateTask_SavesCorrectly() {
        let rTaskCD = self.sut.saveNewRepeatingTask(with: self.rTask)
        
        XCTAssertEqual(rTaskCD.title, self.rTask.title)
        XCTAssertEqual(rTaskCD.desc, self.rTask.desc)
        XCTAssertEqual(rTaskCD.taskUUID, self.rTask.taskUUID)
        XCTAssertEqual(rTaskCD.startDate, self.rTask.startDate.startOfDay)
        XCTAssertEqual(rTaskCD.time, self.rTask.time)
        XCTAssertEqual(rTaskCD.repeatSettings.peroid, Int16(self.rTask.repeatSettings.number))
        XCTAssertEqual(rTaskCD.endDate, self.rTask.endDate)
        XCTAssertEqual(rTaskCD.notificationsEnabled, self.rTask.notificationsEnabled)
    }
}


// MARK: - Read
extension RepeatingTaskManagerTests {
    
    func testRepeatingTaskManager_FetchAllTasks_ReturnsTwoTasks() {
        // Arrange
        let rTaskOne = self.rTask
        let rTaskTwo = RepeatingTask(title: "My second task", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24*45), time: nil, repeatSettings: .yearly, endDate: nil, notificationsEnabled: false)
        
        self.sut.saveNewRepeatingTask(with: rTaskOne)
        self.sut.saveNewRepeatingTask(with: rTaskTwo)
        
        // Act
        let fetchedTasks = self.sut.fetchAllRepeatingTasks()
        let rTaskOneFetched = fetchedTasks.first(where: { $0.taskUUID == rTaskOne.taskUUID })
        let rTaskTwoFetched = fetchedTasks.first(where: { $0.taskUUID == rTaskTwo.taskUUID })
        
        // Assert
        XCTAssertEqual(fetchedTasks.count, 2)
        XCTAssertNotNil(rTaskOneFetched)
        XCTAssertNotNil(rTaskTwoFetched)
    }
    
    func testRepeatingTaskManager_FetchRepeatingTasksStartingFromDate_ReturnsSixTasks() {
        // Arrange
        for x in 0...11 {
            let rTask = RepeatingTask(title: "Repeating Task #\(x)", desc: "desc #\(x)", taskUUID: UUID(), isCompleted: false, startDate: Date().startOfDay.addingTimeInterval(TimeInterval(60*60*8*x)), time: Date().startOfDay.addingTimeInterval(TimeInterval(60*x)), repeatSettings: .daily, endDate: nil, notificationsEnabled: false)
            self.sut.saveNewRepeatingTask(with: rTask)
        }
        
        // Act
        let taskCount = self.sut.fetchRepeatingTasks(on: Date().addingTimeInterval(60*60*24).startOfDay).count
        
        // Assert
        XCTAssertEqual(taskCount, 6)
    }
    
    func testNonRepeatingTaskManager_FetchCompletedTaskCount_ReturnsFive() {
        // Arrage
        let rTask = RepeatingTask(
            title: "My rep task",
            desc: "A description for my rep task",
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(60*60*24*(-5)),
            time: Date(),
            repeatSettings: .daily,
            endDate: Date().addingTimeInterval(60*60*24*4),
            notificationsEnabled: false
        )
        self.sut.saveNewRepeatingTask(with: rTask)
        XCTAssertEqual(self.sut.fetchRepeatingTaskCompletedCount(for: rTask), 0)
        
        // Act
        for x in 0...4 {
            self.sut.setTaskCompleted(with: rTask, for: Date().addingTimeInterval(TimeInterval(60*60*24*(-1)*x)))
        }
        
        // Assert
        XCTAssertEqual(self.sut.fetchRepeatingTaskCompletedCount(for: rTask), 5)
    }
    
    
    // TODO - fetchRepeatingTasks(on date: Date) returns correct isCompleted
    
    // TODO - fetchRepeatingTasks(on date: Date) returns correctly filtered RepeatSettings
    
    // TODO - Test filtering fetchRepeatingTasks(on date: Date) on RepeatSettings
}


// MARK: - Update
extension RepeatingTaskManagerTests {
    
    func testNonRepeatingTaskManager_UpdateTask() {
        // Arrange
        let rTask = RepeatingTask(
            title: "My rep task",
            desc: "A description for my rep task",
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(60*60*24*(-3)),
            time: Date(),
            repeatSettings: .daily,
            endDate: Date().addingTimeInterval(60*60*24*4),
            notificationsEnabled: false
        )
        
        self.sut.saveNewRepeatingTask(with: rTask)
        
        let rTaskUpdated = RepeatingTask(
            title: "My rep task UPDATED",
            desc: "A description for my rep task UPDATED",
            taskUUID: rTask.taskUUID,
            isCompleted: true,
            startDate: Date().addingTimeInterval(60*60*24*(-6)),
            time: Date().addingTimeInterval(60*60*3),
            repeatSettings: .weekly([1, 2, 3]),
            endDate: Date().addingTimeInterval(60*60*24*12),
            notificationsEnabled: true
        )
        
        // Act
        self.sut.updateRepeatingTask(with: rTaskUpdated)
        let rTaskFetched = self.sut.fetchAllRepeatingTasks().first(where: { $0.taskUUID == rTask.taskUUID })
        
        XCTAssertNotNil(rTaskFetched)
        XCTAssertEqual(rTaskFetched?.title, rTaskUpdated.title)
        XCTAssertEqual(rTaskFetched?.desc, rTaskUpdated.desc)
        XCTAssertEqual(rTaskFetched?.startDate, rTaskUpdated.startDate)
        XCTAssertEqual(rTaskFetched?.time, rTaskUpdated.time)
        XCTAssertEqual(rTaskFetched?.repeatSettings, rTaskUpdated.repeatSettings)
        XCTAssertEqual(rTaskFetched?.endDate, rTaskUpdated.endDate)
        XCTAssertEqual(rTaskFetched?.notificationsEnabled, rTaskUpdated.notificationsEnabled)
    }
    
    func testNonRepeatingTaskManager_SetTaskCompleted_OnlyTomorrowReturnsCompleted() {
        // Arrange
        let rTask = self.rTask
        self.sut.saveNewRepeatingTask(with: rTask)
        
        let isAlreadyCompleted = self.sut.isTaskMarkedCompleted(with: rTask, for: Date().addingTimeInterval(60*60*24))
        XCTAssertFalse(isAlreadyCompleted)
        
        // Act
        self.sut.setTaskCompleted(with: rTask, for: Date().addingTimeInterval(60*60*24))
        
        // Assert
        let isYesterdayCompleted = self.sut.isTaskMarkedCompleted(with: rTask, for: Date().addingTimeInterval(60*60*24*(-1)))
        let isTodayCompleted = self.sut.isTaskMarkedCompleted(with: rTask, for: Date())
        let isTomorrowCompleted = self.sut.isTaskMarkedCompleted(with: rTask, for: Date().addingTimeInterval(60*60*24))
        let isDayAfterCompleted = self.sut.isTaskMarkedCompleted(with: rTask, for: Date().addingTimeInterval(60*60*2482))
        
        XCTAssertFalse(isYesterdayCompleted)
        XCTAssertFalse(isTodayCompleted)
        XCTAssertTrue(isTomorrowCompleted)
        XCTAssertFalse(isDayAfterCompleted)
    }
    
    func testNonRepeatingTaskManager_DeleteCompletedRepeatingTask_DeletesCompletedTask() {
        // Arrange
        let rTask = self.rTask
        self.sut.saveNewRepeatingTask(with: rTask)
        
        let completedDate = Date().addingTimeInterval(60*60*24)
        
        let isAlreadyCompleted = self.sut.isTaskMarkedCompleted(with: rTask, for: completedDate)
        XCTAssertFalse(isAlreadyCompleted)
        
        self.sut.setTaskCompleted(with: rTask, for: completedDate)
        let isNowCompleted = self.sut.isTaskMarkedCompleted(with: rTask, for: completedDate)
        XCTAssertTrue(isNowCompleted)
        
        // Act
        self.sut.deleteCompletedRepeatingTask(with: rTask, for: completedDate)
        
        // Assert
        let isDeleted = !self.sut.isTaskMarkedCompleted(with: rTask, for: completedDate)
        XCTAssertTrue(isDeleted)
    }
}




// MARK: - Destroy
extension RepeatingTaskManagerTests {
    
    func testNonRepeatingTaskManager_DeleteThisAndFutureRepeatingTask_TaskIsDeletedForAllDaysAfterGivenDate() {
        // Arrange
        let today = Date()
        let tomorrow_endDate = Date().addingTimeInterval(60*60*24)
        let twoDaysFromNow = Date().addingTimeInterval(60*60*24*2)
        
        let rTask = RepeatingTask(
            title: "My repeating task",
            desc: "My description!",
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: Date().addingTimeInterval(60*60*3.5),
            repeatSettings: .daily,
            endDate: nil,
            notificationsEnabled: false
        )
        self.sut.saveNewRepeatingTask(with: rTask)
        
        var fetchedTask = self.sut.fetchRepeatingTasks(on: today).first
        XCTAssertNotNil(fetchedTask)
        
        fetchedTask = self.sut.fetchRepeatingTasks(on: tomorrow_endDate).first
       XCTAssertNotNil(fetchedTask)
        
        fetchedTask = self.sut.fetchRepeatingTasks(on: twoDaysFromNow).first
        XCTAssertNotNil(fetchedTask)
        
        // Act
        self.sut.deleteThisAndFutureRepeatingTask(with: rTask, deleteDate: tomorrow_endDate)
        
        // Assert
        fetchedTask = self.sut.fetchRepeatingTasks(on: today).first
        XCTAssertEqual(fetchedTask?.endDate, tomorrow_endDate.startOfDay, "endDate was not set when it should have been.")
        XCTAssertNotNil(fetchedTask, "The task should still be returned because it's not deleted until tomorrow.")
        
        fetchedTask = self.sut.fetchRepeatingTasks(on: tomorrow_endDate).first
        XCTAssertNil(fetchedTask, "The tasks should be deleted and nil.")
        
        fetchedTask = self.sut.fetchRepeatingTasks(on: twoDaysFromNow).first
        XCTAssertNil(fetchedTask, "The tasks should be deleted and nil.")
    }
    
    func testNonRepeatingTaskManager_completelyDeleteRepeatingTask() {
        // Arrange
        let rTask = self.rTask
        self.sut.saveNewRepeatingTask(with: rTask)
        self.sut.setTaskCompleted(with: rTask, for: Date())
        
        XCTAssertEqual(self.sut.fetchAllRepeatingTasks().count, 1)
        XCTAssertTrue(self.sut.isTaskMarkedCompleted(with: rTask, for: Date()))
        
        // Act
        self.sut.completelyDeleteRepeatingTask(with: rTask)
        
        // Assert
        XCTAssertEqual(self.sut.fetchAllRepeatingTasks().count, 0)
        XCTAssertFalse(self.sut.isTaskMarkedCompleted(with: rTask, for: Date()))
    }
    
}
