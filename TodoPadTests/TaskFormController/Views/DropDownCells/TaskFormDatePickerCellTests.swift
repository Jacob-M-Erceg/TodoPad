//
//  TaskFormDatePickerCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-09.
//

import XCTest
@testable import TodoPad

class TaskFormDatePickerCellTests: XCTestCase {
    
    var sut: TaskFormDatePickerCell!

    override func setUpWithError() throws {
        self.sut = TaskFormDatePickerCell()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testTaskFormDatePickerCell_ConfigureWithoutIsEnabledAndIsExpandedSetTrue_OptionsAreNotSet() {
        // Arrange
        let taskFormCellModel = TaskFormCellModel(cellType: .startDate)
        
        let startDate = Date()
        let taskFormModel = TaskFormModel(startDate: startDate)
        
        // Act
        self.sut.configure(with: taskFormCellModel, and: taskFormModel)
        
        // Assert
        XCTAssertNotEqual(self.sut.datePicker.datePickerMode, .date, "DatePickerMode is set correctly, when it it should not be because isEnabled & isExpanded are not true.")
        XCTAssertNotEqual(self.sut.datePicker.date, startDate, "The DatePicker Date should not match the startDate passed into the cell because isEnabled & isExpanded are not true.")
    }
    
    func testTaskFormDatePickerCell_ConfigureWithStartDate_StartDateOptionsAreSet() {
        // Arrange
        var taskFormCellModel = TaskFormCellModel(cellType: .startDate)
        taskFormCellModel.setIsEnabled(isEnabled: true)
        taskFormCellModel.setIsExpanded(isExpanded: true)
        
        let startDate = Date()
        let taskFormModel = TaskFormModel(startDate: startDate)
        
        // Act
        self.sut.configure(with: taskFormCellModel, and: taskFormModel)
        
        // Assert
        XCTAssertEqual(self.sut.datePicker.datePickerMode, .date, "DatePickerMode should be .date for StartDate Cell.")
        XCTAssertEqual(self.sut.datePicker.date, startDate, "The DatePicker Date does not match the startDate passed into the cell.")
        XCTAssertEqual(self.sut.taskFormCellModel.cellType, TaskFormCellModel(cellType: .startDate).cellType, "The TaskFormCellModel.cellType superclass variable is not .startDate")
    }
    
    func testTaskFormDatePickerCell_ConfigureWithTime_TimeOptionsAreSet() {
        // Arrange
        var taskFormCellModel = TaskFormCellModel(cellType: .time)
        taskFormCellModel.setIsEnabled(isEnabled: true)
        taskFormCellModel.setIsExpanded(isExpanded: true)
        
        let time = Date()
        let taskFormModel = TaskFormModel(time: time)
        
        // Act
        self.sut.configure(with: taskFormCellModel, and: taskFormModel)
        
        // Assert
        XCTAssertEqual(self.sut.datePicker.datePickerMode, .time, "DatePickerMode should be .time for Time Cell.")
        XCTAssertEqual(self.sut.datePicker.date, time, "The DatePicker Date does not match the time variable passed into the cell.")
        XCTAssertEqual(self.sut.taskFormCellModel.cellType, TaskFormCellModel(cellType: .time).cellType, "The TaskFormCellModel.cellType superclass variable is not .time")
    }
    
    func testTaskFormDatePickerCell_ConfigureWithEndDate_EndDateOptionsAreSet() {
        // Arrange
        var taskFormCellModel = TaskFormCellModel(cellType: .endDate)
        taskFormCellModel.setIsEnabled(isEnabled: true)
        taskFormCellModel.setIsExpanded(isExpanded: true)
        
        let endDate = Date()
        let taskFormModel = TaskFormModel(endDate: endDate)
        
        // Act
        self.sut.configure(with: taskFormCellModel, and: taskFormModel)
        
        // Assert
        XCTAssertEqual(self.sut.datePicker.datePickerMode, .date, "DatePickerMode should be .endDate for EndDate Cell.")
        XCTAssertEqual(self.sut.datePicker.date, endDate, "The DatePicker Date does not match the endDate variable passed into the cell.")
        XCTAssertEqual(self.sut.taskFormCellModel.cellType, TaskFormCellModel(cellType: .endDate).cellType, "The TaskFormCellModel.cellType superclass variable is not .endDate")
    }
    
    func testTaskFormDatePickerCell_DatePickerChanged_DelegateFunctionCalled() {
        // Arrange
        var taskFormCellModel = TaskFormCellModel(cellType: .startDate)
        taskFormCellModel.setIsEnabled(isEnabled: true)
        taskFormCellModel.setIsExpanded(isExpanded: true)
        
        let taskFormModel = TaskFormModel(startDate: Date())
        
        self.sut.configure(with: taskFormCellModel, and: taskFormModel)
        
        let mockDelegate = MockTaskFormDatePickerCellDelegate(testCase: self)
        self.sut.delegate = mockDelegate
        
        // Act
        mockDelegate.expectDate()
        self.sut.datePicker.sendActions(for: .valueChanged)
        
        // Assert
        XCTAssertEqual(self.sut.datePicker.date, mockDelegate.date, "DatePicker date does not match the date passed back through delegate.")
        waitForExpectations(timeout: 1)
    }
}
