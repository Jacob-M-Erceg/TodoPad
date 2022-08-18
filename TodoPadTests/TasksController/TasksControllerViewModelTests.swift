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
