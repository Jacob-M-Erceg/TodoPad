//
//  StatsControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-24.
//

import XCTest
@testable import TodoPad

class StatsControllerTests: XCTestCase {
    
    var sut: StatsController!
    
    var pTaskManager: PersistentTaskManager!
    var rTaskManager: RepeatingTaskManager!
    var nonRepTaskManager: NonRepeatingTaskManager!

    override func setUpWithError() throws {
        let context = CoreDataTestStack().context
        
        self.pTaskManager = PersistentTaskManager(context: context)
        self.rTaskManager = RepeatingTaskManager(context: context)
        self.nonRepTaskManager = NonRepeatingTaskManager(context: context)
        
        let viewModel = StatsControllerViewModel(persistentTaskManager: pTaskManager, repeatingTaskManager: rTaskManager, nonRepeatingTaskManager: nonRepTaskManager)
        
        self.sut = StatsController(viewModel)
        self.sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        self.sut = nil
        self.pTaskManager = nil
        self.rTaskManager = nil
        self.nonRepTaskManager = nil
    }
    
    func testInit_TableViewHeader_NotNil() {
        // Assert
        XCTAssertNotNil(self.sut.header)
    }
    
    func testViewWillAppear_HeaderConfiured_LabelsTextNotError() {
        // Act
        self.sut.viewWillAppear(true) 
        
        // Assert
        XCTAssertNotEqual(self.sut.header?.levelLabel.text, "Error", "Error is the default value for StatsTableViewHeader labels. If it was not changed, this means the header was not configured when viewWillAppear is called.")
        XCTAssertNotEqual(self.sut.header?.tasksCompletedLabel.text, "Error", "Error is the default value for StatsTableViewHeader labels. If it was not changed, this means the header was not configured when viewWillAppear is called.")
    }
    
    func testViewWillAppear_fetchDataCalled_LabelsUpdated() {
        // Arrange & Act
        self.sut.viewWillAppear(true)
        
        let tasksCompletedLabel = self.sut.header?.tasksCompletedLabel.text
        
        let rTask = RepeatingTask.getMockRepeatingTask
        self.sut.viewModel.repeatingTaskManager.saveNewRepeatingTask(with: rTask)
        self.sut.viewModel.repeatingTaskManager.setTaskCompleted(with: rTask, for: Date().addingTimeInterval(-2*60*60*24))
        
        self.sut.viewWillAppear(true)
        
        // Assert
        XCTAssertNotEqual(self.sut.header?.tasksCompletedLabel.text, tasksCompletedLabel)
    }
}

// MARK: - TableView
extension StatsControllerTests {
    
    func testTableView_NumberOfRowsInSection_Returns9() {
        // Arrange
        for rTask in RepeatingTask.getMockRepeatingTaskArray {
            self.rTaskManager.saveNewRepeatingTask(with: rTask)
        }
        self.sut.viewModel.fetchData()
        
        // Act
        let cellCount = self.sut.tableView.dataSource?.tableView(self.sut.tableView, numberOfRowsInSection: 0)
        
        // Assert
        XCTAssertEqual(cellCount, 9)
    }
    
    func testTableView_CellForRowAt_StatsCellNotNil() {
        // Arrange
        self.rTaskManager.saveNewRepeatingTask(with: RepeatingTask.getMockRepeatingTask)
        self.sut.viewModel.fetchData()
        
        // Act
        self.sut.tableView.reloadData()
        let cell = self.sut.tableView.dataSource?.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? StatsCell
        
        // Assert
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.taskTitleLabel.text, RepeatingTask.getMockRepeatingTask.title)
    }
    
    func testTableView_HeightForRowAt_Returns119() {
        // Act
        let height = self.sut.tableView.delegate?.tableView?(self.sut.tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        
        // Assert
        XCTAssertEqual(height, 119)
    }
}
