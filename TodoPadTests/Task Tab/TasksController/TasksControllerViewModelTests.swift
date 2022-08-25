//
//  TasksControllerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-03.
//

import XCTest
@testable import TodoPad

class TasksControllerViewModelTests: XCTestCase {
    
    var sut: TasksControllerViewModel!
    
    var pTaskManager: PersistentTaskManager!
    var nonRepTaskManager: NonRepeatingTaskManager!
    var rTaskManager: RepeatingTaskManager!
    
    
    override func setUpWithError() throws {
        let testContext = CoreDataTestStack().context
        
        self.pTaskManager = PersistentTaskManager(context: testContext)
        self.nonRepTaskManager = NonRepeatingTaskManager(context: testContext)
        self.rTaskManager = RepeatingTaskManager(context: testContext)
        
        self.sut = TasksControllerViewModel(persistentTaskManager: pTaskManager, repeatingTaskManager: rTaskManager, nonRepeatingTaskManager: nonRepTaskManager)
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
        self.pTaskManager = nil
        self.nonRepTaskManager = nil
        self.rTaskManager = nil
    }
}

// MARK: - Initialization
extension TasksControllerViewModelTests {
    
    func testTasksControllerViewModel_WhenInitalized_SelectedDateIsToday() {
        // Assert
        XCTAssertEqual(
            sut.selectedDate.timeIntervalSince1970,
            Date().timeIntervalSince1970,
            accuracy: 0.1,
            "When TasksControllerViewModel was initialized the selectedDate variable was not today."
        )
    }
    
    func testTasksControllerViewModel_WhenChangeSelectedDateCalled_SelectedDateChanges() {
        // Arrange
        let originalDate = sut.selectedDate
        
        // Act
        sut.changeSelectedDate(with: Date().addingTimeInterval(60*60*24*99))
        
        // Assert
        XCTAssertNotEqual(
            originalDate.timeIntervalSince1970,
            sut.selectedDate.timeIntervalSince1970,
            "When TasksControllerViewModel.changeSelectedDate() was called, the selectedDate variable did not change."
        )
    }
    
    //    func test_openOrCloseTaskGroupSectionCalled_TaskGroupOpenedOrClosed() {
    //        // Arrange
    //        let taskGroup = self.sut.taskGroups[0]
    //
    //        self.sut.onExpandCloseGroup = { [weak self] indexPaths, isOpening in
    //            if isOpening {
    //                devPrint("isOpening")
    //            } else {
    //                devPrint("isNotOpening")
    //            }
    //        }
    //
    //        // Act
    //        self.sut.openOrCloseTaskGroupSection(for: taskGroup)
    //
    //        // Assert
    //    }
}


// MARK: - Task Groups
extension TasksControllerViewModelTests {
    
    func testopenOrCloseTaskGroupSection_WhenClosedAndOpened_TaskGroupChanges() {
        // In Progress Group
        let inProgGroup = TaskGroup(title: "In Progress")
        
        self.sut.openOrCloseTaskGroupSection(for: inProgGroup) // Closed
        XCTAssertFalse(self.sut.taskGroups.first(where: { $0.title == "In Progress" })?.isOpened ?? true)
        
        self.sut.openOrCloseTaskGroupSection(for: inProgGroup) // Opened
        XCTAssertTrue(self.sut.taskGroups.first(where: { $0.title == "In Progress" })?.isOpened ?? true)
        
        // Completed Group
        let completedGroup = TaskGroup(title: "Completed")
        
        self.sut.openOrCloseTaskGroupSection(for: completedGroup) // Closed
        XCTAssertFalse(self.sut.taskGroups.first(where: { $0.title == "Completed" })?.isOpened ?? true)
        
        self.sut.openOrCloseTaskGroupSection(for: completedGroup) // Closed
        XCTAssertTrue(self.sut.taskGroups.first(where: { $0.title == "Completed" })?.isOpened ?? true)
    }
    
    func testopenOrCloseTaskGroupSection_onExpandCloseGroupCallback_isOpenIsFalseAndTwoIndexPaths() {
        // Arrange
        self.sut.onExpandCloseGroup = { indexPaths, isOpen in
            XCTAssertFalse(isOpen)
            
            XCTAssertEqual(indexPaths.count, 2)
            XCTAssertEqual(indexPaths[0].row, 0)
            XCTAssertEqual(indexPaths[1].row, 1)
        }
        
        self.sut.persistentTaskManager.saveNewPersistentTask(with: PersistentTask(title: "1", desc: nil, taskUUID: UUID(), dateCompleted: nil))
        self.sut.persistentTaskManager.saveNewPersistentTask(with: PersistentTask(title: "2", desc: nil, taskUUID: UUID(), dateCompleted: Date()))
        self.sut.persistentTaskManager.saveNewPersistentTask(with: PersistentTask(title: "3", desc: nil, taskUUID: UUID(), dateCompleted: Date()))
        self.sut.persistentTaskManager.saveNewPersistentTask(with: PersistentTask(title: "4", desc: nil, taskUUID: UUID(), dateCompleted: nil))
        self.sut.persistentTaskManager.saveNewPersistentTask(with: PersistentTask(title: "5", desc: nil, taskUUID: UUID(), dateCompleted: Date()))
        
        self.sut.fetchTasks(for: self.sut.selectedDate)
        
        let inProgGroup = TaskGroup(title: "In Progress")
        self.sut.openOrCloseTaskGroupSection(for: inProgGroup)
    }
    
}


// MARK: - Fetch & Refresh Tasks
extension TasksControllerViewModelTests {
    
    func testFetchTasks_TasksInCorrectTaskGroups_FiveInTaskCompletedFourteenInInProgress() {
        // Arrange
        for rTask in RepeatingTask.getMockRepeatingTaskArray {
            self.rTaskManager.saveNewRepeatingTask(with: rTask)
        }
        
        for pTask in PersistentTask.getMockPersistentTaskArray {
            self.pTaskManager.saveNewPersistentTask(with: pTask)
        }
        
        for nonRepTask in NonRepeatingTask.getMockNonRepeatingTaskArray {
            self.nonRepTaskManager.saveNewNonRepeatingTask(with: nonRepTask)
        }
        
        // Act
        self.sut.fetchTasks(for: self.sut.selectedDate)
        
        // Assert
        XCTAssertEqual(self.sut.taskGroups[0].tasks.count, 14)
        XCTAssertEqual(self.sut.taskGroups[1].tasks.count, 5)
    }
    
    func testFetchTasks_SortedByTime() {
        // Arrange
        for rTask in RepeatingTask.getMockRepeatingTaskArray {
            self.rTaskManager.saveNewRepeatingTask(with: rTask)
        }
        
        for pTask in PersistentTask.getMockPersistentTaskArray {
            self.pTaskManager.saveNewPersistentTask(with: pTask)
        }
        
        for nonRepTask in NonRepeatingTask.getMockNonRepeatingTaskArray {
            self.nonRepTaskManager.saveNewNonRepeatingTask(with: nonRepTask)
        }
        
        // Act
        self.sut.fetchTasks(for: self.sut.selectedDate)
        
        // Assert
        let inProgressTasks = self.sut.taskGroups[1].tasks
        let completedTasks = self.sut.taskGroups[1].tasks
        
        for x in 0...inProgressTasks.count-2 {
            if let task1Time = inProgressTasks[x].time?.comparableByTime,
               let task2Time = inProgressTasks[x+1].time?.comparableByTime {
                XCTAssertLessThanOrEqual(task1Time, task2Time)
            }
        }
        
        for x in 0...completedTasks.count-2 {
            if let task1Time = completedTasks[x].time?.comparableByTime,
               let task2Time = completedTasks[x+1].time?.comparableByTime {
                XCTAssertLessThanOrEqual(task1Time, task2Time)
            }
        }
    }
    
    
    func testFetchRepeatingTasks_ReturnsNineTasks() {
        // Arrange
        for rTask in RepeatingTask.getMockRepeatingTaskArray {
            self.rTaskManager.saveNewRepeatingTask(with: rTask)
        }
        
        // Act
        let tasks = self.sut.fetchRepeatingTasks(for: self.sut.selectedDate)
        
        // Assert
        XCTAssertEqual(tasks.count, RepeatingTask.getMockRepeatingTaskArray.count)
    }
    
    func testFetchPersistentTask_ReturnsSevenTasks() {
        // Arrange
        for pTask in PersistentTask.getMockPersistentTaskArray {
            self.pTaskManager.saveNewPersistentTask(with: pTask)
        }
        
        // Act
        let tasks = self.sut.fetchPersistentTask(for: self.sut.selectedDate)
        
        // Assert
        XCTAssertEqual(tasks.count, PersistentTask.getMockPersistentTaskArray.count)
    }
    
    func testFetchNonRepeatingTasks_ReturnsNineTasks() {
        // Arrange
        for nonRepTask in NonRepeatingTask.getMockNonRepeatingTaskArray {
            self.nonRepTaskManager.saveNewNonRepeatingTask(with: nonRepTask)
        }
        
        // Act
        let tasks = self.sut.fetchNonRepeatingTask(for: self.sut.selectedDate)
        
        // Assert
        XCTAssertEqual(tasks.count, NonRepeatingTask.getMockNonRepeatingTaskArray.count)
    }
}


// MARK: - TaskCompleted Functions
extension TasksControllerViewModelTests {
    
    func testInvertAndIsTaskCompleted_RepeatingTask() {
        // Arrange
        var rTask = RepeatingTask(title: "Repeating Task", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date(), time: nil, repeatSettings: .daily, endDate: nil, notificationsEnabled: false)
        self.sut.repeatingTaskManager.saveNewRepeatingTask(with: rTask)
        rTask = self.sut.fetchRepeatingTasks(for: rTask.startDate).compactMap({ $0.getRepeatingTask })[0]
        
        // Assert & Act
        XCTAssertFalse(self.sut.isTaskCompleted(with: Task.repeating(rTask)))
        self.sut.invertTaskCompleted(with: Task.repeating(rTask))
        rTask = self.sut.fetchRepeatingTasks(for: rTask.startDate).compactMap({ $0.getRepeatingTask })[0]
        
        XCTAssertTrue(self.sut.isTaskCompleted(with: Task.repeating(rTask)))
        self.sut.invertTaskCompleted(with: Task.repeating(rTask))
        rTask = self.sut.fetchRepeatingTasks(for: rTask.startDate).compactMap({ $0.getRepeatingTask })[0]
        
        XCTAssertFalse(self.sut.isTaskCompleted(with: Task.repeating(rTask)))
    }
    
    func testInvertAndIsTaskCompleted_NonRepeatingTask() {
        // Arrange
        var nonRepTask = NonRepeatingTask(title: "NonRep Task", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date(), time: nil, notificationsEnabled: false)
        self.sut.nonRepeatingTaskManager.saveNewNonRepeatingTask(with: nonRepTask)
        nonRepTask = self.sut.fetchNonRepeatingTask(for: nonRepTask.date).compactMap({ $0.getNonRepeatingTask })[0]
        
        // Assert & Act
        XCTAssertFalse(self.sut.isTaskCompleted(with: Task.nonRepeating(nonRepTask)))
        self.sut.invertTaskCompleted(with: Task.nonRepeating(nonRepTask))
        nonRepTask = self.sut.fetchNonRepeatingTask(for: nonRepTask.date).compactMap({ $0.getNonRepeatingTask })[0]
        
        XCTAssertTrue(self.sut.isTaskCompleted(with: Task.nonRepeating(nonRepTask)))
        self.sut.invertTaskCompleted(with: Task.nonRepeating(nonRepTask))
        nonRepTask = self.sut.fetchNonRepeatingTask(for: nonRepTask.date).compactMap({ $0.getNonRepeatingTask })[0]
        
        XCTAssertFalse(self.sut.isTaskCompleted(with: Task.nonRepeating(nonRepTask)))
    }
    
    func testInvertAndIsTaskCompleted_PersistentTask() {
        // Arrange
        var pTask = PersistentTask(title: "Persistent Task", desc: nil, taskUUID: UUID(), dateCompleted: nil)
        self.sut.persistentTaskManager.saveNewPersistentTask(with: pTask)
        pTask = self.sut.fetchPersistentTask(for: Date()).compactMap({ $0.getPersistentTask })[0]
        
        // Assert & Act
        XCTAssertFalse(self.sut.isTaskCompleted(with: Task.persistent(pTask)))
        self.sut.invertTaskCompleted(with: Task.persistent(pTask))
        pTask = self.sut.fetchPersistentTask(for: Date()).compactMap({ $0.getPersistentTask })[0]
        
        XCTAssertTrue(self.sut.isTaskCompleted(with: Task.persistent(pTask)))
        self.sut.invertTaskCompleted(with: Task.persistent(pTask))
        pTask = self.sut.fetchPersistentTask(for: Date()).compactMap({ $0.getPersistentTask })[0]
        
        XCTAssertFalse(self.sut.isTaskCompleted(with: Task.persistent(pTask)))
    }
}


// MARK: - Delete Task Functions
extension TasksControllerViewModelTests {
    
    func testDeleteTaskFunction_WhenNonRepeatingTask_DeletesRepeatingTaskFromCoreData() {
        // Arrange
        let nonRepTask = NonRepeatingTask.getMockNonRepeatingTask
        self.nonRepTaskManager.saveNewNonRepeatingTask(with: nonRepTask)
        
        var nonRepTaskCount = self.nonRepTaskManager.fetchNonRepeatingTasks(for: nonRepTask.date).count
        XCTAssertEqual(nonRepTaskCount, 1)
        
        // Act
        self.sut.deleteTask(for: Task.nonRepeating(nonRepTask))
        
        // Assert
        nonRepTaskCount = self.nonRepTaskManager.fetchNonRepeatingTasks(for: nonRepTask.date).count
        XCTAssertEqual(nonRepTaskCount, 0)
    }
    
    func testDeleteTaskFunction_WhenPersistentTask_DeletesPersistentTaskFromCoreData() {
        // Arrange
        let pTask = PersistentTask.getMockPersistentTask
        self.pTaskManager.saveNewPersistentTask(with: pTask)
        
        var pTaskCount = self.pTaskManager.fetchAllPersistentTasks().count
        XCTAssertEqual(pTaskCount, 1)
        
        // Act
        self.sut.deleteTask(for: Task.persistent(pTask))
        
        // Assert
        pTaskCount = self.pTaskManager.fetchAllPersistentTasks().count
        XCTAssertEqual(pTaskCount, 0)
    }
    
    func testDeleteRepeatingTaskForThisAndFutureDays_DeletesThisAndFutureDays() {
        // Arrange
        let rTask = RepeatingTask(
            title: "rTask",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-14*60*60*24),
            time: nil,
            repeatSettings: .daily,
            endDate: nil,
            notificationsEnabled: false
        )
        self.rTaskManager.saveNewRepeatingTask(with: rTask)
        
        for x in -14...14 {
            let tasks = self.rTaskManager.fetchRepeatingTasks(on: Date().addingTimeInterval(TimeInterval(x*60*60*24)))
            XCTAssertEqual(tasks.count, 1)
            XCTAssertNotNil(tasks.first, "Task should not have been nil \(x) from now. (Iteration \(x))")
        }
        
        // Act
        self.sut.deleteRepeatingTaskForThisAndFutureDays(for: rTask, selectedDate: Date().addingTimeInterval(7*60*60*24))
        
        // Assert
        for x in -14...6 {
            let tasks = self.rTaskManager.fetchRepeatingTasks(on: Date().addingTimeInterval(TimeInterval(x*60*60*24)))
            XCTAssertEqual(tasks.count, 1)
            XCTAssertNotNil(tasks.first, "Task should not have been nil \(x) from now. (Iteration \(x))")
        }
        for x in 7...14 {
            let tasks = self.rTaskManager.fetchRepeatingTasks(on: Date().addingTimeInterval(TimeInterval(x*60*60*24)))
            XCTAssertEqual(tasks.count, 0)
            XCTAssertNil(tasks.first, "Task should have been nil \(x) from now. (Iteration \(x))")
        }
    }
    
    func testCompletelyDeleteRepeatingTask_CompletelyDeletesRepeatingTasksFromCoreData() {
        // Arrange
        let rTask = RepeatingTask(
            title: "rTask",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date().addingTimeInterval(-14*60*60*24),
            time: nil,
            repeatSettings: .daily,
            endDate: nil,
            notificationsEnabled: false
        )
        self.rTaskManager.saveNewRepeatingTask(with: rTask)
        
        for x in -14...14 {
            let tasks = self.rTaskManager.fetchRepeatingTasks(on: Date().addingTimeInterval(TimeInterval(x*60*60*24)))
            XCTAssertEqual(tasks.count, 1)
            XCTAssertNotNil(tasks.first, "Task should not have been nil \(x) from now. (Iteration \(x))")
        }
        
        // Act
        self.sut.completelyDeleteRepeatingTask(for: rTask)
        
        // Assert
        for x in -14...14 {
            let tasks = self.rTaskManager.fetchRepeatingTasks(on: Date().addingTimeInterval(TimeInterval(x*60*60*24)))
            XCTAssertEqual(tasks.count, 0)
            XCTAssertNil(tasks.first, "Task should have been nil \(x) from now. (Iteration \(x))")
        }
    }
}
