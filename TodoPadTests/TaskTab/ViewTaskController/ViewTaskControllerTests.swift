//
//  ViewTaskControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-18.
//

import XCTest
@testable import TodoPad

class ViewTaskControllerTests: XCTestCase {
    
    var sut: ViewTaskController!

    override func setUpWithError() throws {
        let nonRepTask = NonRepeatingTask(title: "My Title", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date(), time: nil, notificationsEnabled: true)
        let viewModel = ViewTaskControllerViewModel(task: Task.nonRepeating(nonRepTask))
        self.sut = ViewTaskController(viewModel: viewModel)
        self.sut.loadViewIfNeeded()
    }
    
    private func updateSUT(with task: Task) {
        let viewModel = ViewTaskControllerViewModel(task: task)
        self.sut = ViewTaskController(viewModel: viewModel)
        self.sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    // MARK: - TableView Header
    func testTableViewHeader_HeightWhenNoDescription() {
        let height: CGFloat = 28 + // Task Title Label Top Spacing
                              35 + // Task Title Label Height
                              16 + // Description Label Top Spacing
                              0  + // getDescriptionLabelHeight() +
                              40 + // Complete Button Top Spacing
                              44 + // Complete Button Height
                              40 // Complete Button Button Spacing
        
        // Assert
        XCTAssertEqual(sut.tableView.tableHeaderView?.height, height)
    }
    
    func testTableViewHeader_HeightWhenOneLineDescription() {
        // Arrange
        let pTask = PersistentTask(title: "My Title", desc: "Short Desc", taskUUID: UUID(), dateCompleted: nil)
        let viewModel = ViewTaskControllerViewModel(task: Task.persistent(pTask))
        let sut = ViewTaskController(viewModel: viewModel)
        sut.loadViewIfNeeded()
        
        // Assert
        let height: CGFloat = 28 + // Task Title Label Top Spacing
                              35 + // Task Title Label Height
                              16 + // Description Label Top Spacing
                              21.5 + // Description Height
                              40 + // Complete Button Top Spacing
                              44 + // Complete Button Height
                              40 // Complete Button Button Spacing
        
        // Assert
        XCTAssertEqual(sut.tableView.tableHeaderView?.height, height)
    }
    
    func testTableViewHeader_TappedCompleteTask_ClosureIsCalled() {
        // Arrange
        let exception = self.expectation(description: "Complete Task Tapped")
        
        self.sut.onTappedCompleteTask = {
            // Assert
            exception.fulfill()
        }
        
        // Act
        self.sut.didTapCompleteTask()
        
        // Assert
        waitForExpectations(timeout: 3)
    }
    
    
    // MARK: - TableView Cells
    func testTableViewFunctions_NumberOfRowsInSection_WhenStartDateTimeAndNotifications_ReturnsThree() {
        // Arrange
        self.updateSUT(with: Task.nonRepeating(NonRepeatingTask(title: "", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date(), time: Date(), notificationsEnabled: true)))
        
        let cellCount = self.sut.tableView.dataSource?.tableView(self.sut.tableView, numberOfRowsInSection: 0)
        
        // Assert
        XCTAssertEqual(cellCount, 3)
    }
    
    func testTableViewFunctions_CellForRowAt_WhenRepeatingTaskAndRowIsTwo_IsRepeatSettingsViewTaskCell() {
        // Arrange
        let task = RepeatingTask(title: "My Rep Task", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date(), time: nil, repeatSettings: .weekly([1, 2, 5]), endDate: nil, notificationsEnabled: false)
        self.updateSUT(with: Task.repeating(task))
        
        // Act
        self.sut.tableView.reloadData()
        let cell = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? RepeatSettingsViewTaskCell
        
        // Assert
        XCTAssertNotNil(cell)
    }
    
    func testTableViewFunctions_CellForRowAt_WhenNormalViewTaskCell_CellIsNotNil() {
        // Act
        self.sut.tableView.reloadData()
        let cell = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? NormalViewTaskCell
        
        // Assert
        XCTAssertNotNil(cell)
    }
    
    func testTableViewFunctions_HeightForRowAt_RepeatSettingsWeeklyCellReturns122() {
        // Arrange
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
        self.updateSUT(with: Task.repeating(rTask))
        
        // Act
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: IndexPath(row: 2, section: 0))
        
        // Assert
        XCTAssertEqual(height, 122)
    }
    
    func testTableViewDelegate_HeightForRowAt_NormalCellReturns55() {
        // Act
        let height = sut.tableView.delegate?.tableView?(sut.tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // Assert
        XCTAssertEqual(height, 55)
    }
}
