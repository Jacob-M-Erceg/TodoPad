//
//  StatsControllerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-25.
//

import XCTest
import CoreData
@testable import TodoPad

class StatsControllerViewModelTests: XCTestCase {
    
    var sut: StatsControllerViewModel!
    
    var pTaskManager: PersistentTaskManager!
    var rTaskManager: RepeatingTaskManager!
    var nonRepTaskManager: NonRepeatingTaskManager!
    var userDefaultsManager: UserDefaultsManager!

    override func setUpWithError() throws {
        let context = CoreDataTestStack().context
        
        self.pTaskManager = PersistentTaskManager(context: context)
        self.rTaskManager = RepeatingTaskManager(context: context)
        self.nonRepTaskManager = NonRepeatingTaskManager(context: context)
        self.userDefaultsManager = UserDefaultsManager(Constants.statsSortingOptionsIsAscendingKeyTesting, Constants.statsSortingOptionsSortByKeyTesting)
        
        self.sut = StatsControllerViewModel(
            persistentTaskManager: self.pTaskManager,
            repeatingTaskManager: self.rTaskManager,
            nonRepeatingTaskManager: self.nonRepTaskManager,
            userDefaultsManager: self.userDefaultsManager
        )
    }

    override func tearDownWithError() throws {
        self.sut = nil
        self.pTaskManager = nil
        self.rTaskManager = nil
        self.nonRepTaskManager = nil
        self.userDefaultsManager.setStatControllerSortingOptions(with: StatsControllerSortingOptions(isAscending: true, sortBy: .timeOfDay))
        self.userDefaultsManager = nil
    }
    
    func testStatsControllerViewModel_WhenInitialised_FetchesRepeatingTasks_Returns9() {
        // Arrange
        for rTask in RepeatingTask.getMockRepeatingTaskArray {
            self.rTaskManager.saveNewRepeatingTask(with: rTask)
        }
        
        // Act
        // Re-set for initializer
        self.sut = StatsControllerViewModel(persistentTaskManager: pTaskManager, repeatingTaskManager: rTaskManager, nonRepeatingTaskManager: nonRepTaskManager)
        
        // Assert
        XCTAssertEqual(self.sut.repeatingTasks.count, 9)
    }
    
    func testStatsControllerViewModel_WhenInitialised_FetchesCorrectRepeatingTasksCompletedCount_Returns81() {
        // Arrange
        for rTask in RepeatingTask.getMockRepeatingTaskArray {
            self.rTaskManager.saveNewRepeatingTask(with: rTask)
            for x in -8...0 {
                self.rTaskManager.setTaskCompleted(with: rTask, for: Date().addingTimeInterval(TimeInterval(x*2*60*60*24)))
            }
        }
        
        // Act
        // Re-set for initializer
        self.sut = StatsControllerViewModel(persistentTaskManager: pTaskManager, repeatingTaskManager: rTaskManager, nonRepeatingTaskManager: nonRepTaskManager)
        
        // Assert
        var taskCompletedCount = 0
        for rTask in self.sut.repeatingTasks {
            taskCompletedCount += rTask.daysCompleted
        }
        XCTAssertEqual(self.sut.repeatingTasks.count, 9)
        XCTAssertEqual(taskCompletedCount, 81)
    }
    
    func testStatsControllerViewModel_fetchTotalTasksCompletedCount_Returns101() {
        for rTask in RepeatingTask.getMockRepeatingTaskArray {
            self.rTaskManager.saveNewRepeatingTask(with: rTask)
            for x in -8...0 {
                self.rTaskManager.setTaskCompleted(with: rTask, for: Date().addingTimeInterval(TimeInterval(x*2*60*60*24))) //81 Completed
            }
        }
        
        for pTask in PersistentTask.getMockPersistentTaskArray {
            self.pTaskManager.saveNewPersistentTask(with: pTask) // 3 Completed
        }
        
        for nonRepTask in NonRepeatingTask.getMockNonRepeatingTaskArray {
            self.nonRepTaskManager.saveNewNonRepeatingTask(with: nonRepTask) // 2 Completed
        }
        
        // Act
        self.sut = StatsControllerViewModel(persistentTaskManager: pTaskManager, repeatingTaskManager: rTaskManager, nonRepeatingTaskManager: nonRepTaskManager)
        let taskCompletedCount = self.sut.fetchTotalTasksCompletedCount()
        
        // Assert
        XCTAssertEqual(taskCompletedCount, 86)
    }
}

// MARK: - Sorting Repeating Tasks
extension StatsControllerViewModelTests {
    
    // MARK: - Set Sorting Options Function
    func testSetSortingOptionsFunction_UpdatesSortingOptionsVariable_SortedByTimeOfDayAndIsAscendingFalse() {
        // Arrange
        XCTAssertEqual(self.sut.sortingOptions.isAscending, true)
        XCTAssertEqual(self.sut.sortingOptions.sortBy, .timeOfDay)
        
        // Act
        self.sut.setSortingOptions(with: .timeOfDay)
        
        // Assert
        XCTAssertEqual(self.sut.sortingOptions.isAscending, false)
        XCTAssertEqual(self.sut.sortingOptions.sortBy, .timeOfDay)
    }
    
    func testSetSortingOptionsFunction_UpdatesSortingOptionsVariable_SortedByDaysCompletedAndIsAscendingTrue() {
        // Arrange
        XCTAssertEqual(self.sut.sortingOptions.isAscending, true)
        XCTAssertEqual(self.sut.sortingOptions.sortBy, .timeOfDay)
        
        // Act
        self.sut.setSortingOptions(with: .daysCompleted)
        
        // Assert
        XCTAssertEqual(self.sut.sortingOptions.isAscending, true)
        XCTAssertEqual(self.sut.sortingOptions.sortBy, .daysCompleted)
    }
    
    func testSetSortingOptionsFunction_UpdatesUserDefaults() {
        // Arrange
        let originalSortingOptions = self.userDefaultsManager.getStatsControllerSortingOptions
        
        // Act
        self.sut.setSortingOptions(with: .daysCompleted) // Changes sortBy
        self.sut.setSortingOptions(with: .daysCompleted) // Changes isAscending
        
        // Assert
        let afterSortingOptions = self.userDefaultsManager.getStatsControllerSortingOptions
        XCTAssertNotEqual(originalSortingOptions.sortBy, afterSortingOptions.sortBy)
        XCTAssertNotEqual(originalSortingOptions.isAscending, afterSortingOptions.isAscending)
    }
    
    // MARK: - Sort Repeating Tasks Function
    // TODO - 
    
    
}
