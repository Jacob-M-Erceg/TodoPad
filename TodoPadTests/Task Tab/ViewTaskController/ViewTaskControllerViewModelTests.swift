//
//  ViewTaskControllerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-18.
//

import XCTest
@testable import TodoPad

class ViewTaskControllerViewModelTests: XCTestCase {
    
    func testPopulateViewTaskCellModelArrayFunction_InitWithRepeatingTask_OnlyStartDateAndRepeatSettings() {
        // Arrange & Act
        let rTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: nil,
            repeatSettings: .weekly([1, 2, 5]),
            endDate: nil,
            notificationsEnabled: false
        )
        let viewModel = ViewTaskControllerViewModel(task: Task.repeating(rTask))
        
        // Assert
        XCTAssertEqual(viewModel.viewTaskCells.count, 3)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 0]?.title, "Started \(DateHelper.getMonthAndDayString(for: rTask.startDate))")
        XCTAssertEqual(viewModel.viewTaskCells[optional: 1]?.title, "Anytime")
        XCTAssertEqual(viewModel.viewTaskCells[optional: 2]?.title, rTask.repeatSettings.repeatPeroidString)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 2]?.weeklyArray, rTask.repeatSettings.getWeeklyArray)
    }
    
    func testPopulateViewTaskCellModelArrayFunction_InitWithRepeatingTask_TimeAndEndDateAndNotification() {
        // Arrange & Act
        let rTask = RepeatingTask(
            title: "My Rep Task",
            desc: nil,
            taskUUID: UUID(),
            isCompleted: false,
            startDate: Date(),
            time: Date().addingTimeInterval(60*60*3),
            repeatSettings: .yearly,
            endDate: Date().addingTimeInterval(60*60*24*7),
            notificationsEnabled: false
        )
        let viewModel = ViewTaskControllerViewModel(task: Task.repeating(rTask))
        
        // Assert
        XCTAssertEqual(viewModel.viewTaskCells.count, 4)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 0]?.title, "Started \(DateHelper.getMonthAndDayString(for: rTask.startDate))")
        XCTAssertEqual(viewModel.viewTaskCells[optional: 1]?.title, rTask.time?.timeString)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 2]?.title, rTask.repeatSettings.repeatPeroidString)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 2]?.weeklyArray, nil)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 3]?.title, "Ending \(DateHelper.getMonthAndDayString(for: rTask.endDate ?? Date()))")
    }
    
    func testPopulateViewTaskCellModelArrayFunction_InitWithNonRepeatingTask_OnlyDate() {
        // Arrange & Act
        let nonRepTask = NonRepeatingTask(
            title: "My Non Rep Task",
            desc: nil,
            taskUUID: UUID(),
            date: Date(),
            time: nil,
            notificationsEnabled: false
        )
        let viewModel = ViewTaskControllerViewModel(task: Task.nonRepeating(nonRepTask))
        
        // Assert
        XCTAssertEqual(viewModel.viewTaskCells.count, 2)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 0]?.title, DateHelper.getMonthAndDayString(for: nonRepTask.date))
        XCTAssertEqual(viewModel.viewTaskCells[optional: 1]?.title, "Anytime")
    }
    
    func testPopulateViewTaskCellModelArrayFunction_InitWithNonRepeatingTask_NotifAndTime() {
        // Arrange & Act
        let nonRepTask = NonRepeatingTask(
            title: "My Non Rep Task",
            desc: nil,
            taskUUID: UUID(),
            date: Date(),
            time: Date().addingTimeInterval(60*60*3),
            notificationsEnabled: true
        )
        let viewModel = ViewTaskControllerViewModel(task: Task.nonRepeating(nonRepTask))
        
        // Assert
        XCTAssertEqual(viewModel.viewTaskCells.count, 3)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 0]?.title, DateHelper.getMonthAndDayString(for: nonRepTask.date))
        XCTAssertEqual(viewModel.viewTaskCells[optional: 1]?.title, nonRepTask.time?.timeString)
        XCTAssertEqual(viewModel.viewTaskCells[optional: 2]?.title, "Notifications Enabled")
    }
    
    func testPopulateViewTaskCellModelArrayFunction_InitWithPersistentTask_NoViewTaskCells() {
        // Arrange & Act
        let pTask = PersistentTask(title: "My Persistent Task", desc: "My desc", taskUUID: UUID(), dateCompleted: nil)
        let viewModel = ViewTaskControllerViewModel(task: Task.persistent(pTask))
        
        // Assert
        XCTAssertEqual(viewModel.viewTaskCells.count, 0)
    }
}
