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

    override func setUpWithError() throws {
        let context = CoreDataTestStack().context
        
        let pTaskManager = PersistentTaskManager(context: context)
        let rTaskManager = RepeatingTaskManager(context: context)
        let nonRepTaskManager = NonRepeatingTaskManager(context: context)
        
        let viewModel = StatsControllerViewModel(persistentTaskManager: pTaskManager, repeatingTaskManager: rTaskManager, nonRepeatingTaskManager: nonRepTaskManager)
        
        self.sut = StatsController(viewModel)
        self.sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testInit_TableViewHeader_NotNil() {
        // Assert
        XCTAssertNotNil(self.sut.header)
    }
    
    func testViewWillAppear_HeaderConfiured_LabelsTextNotError() {
        // Assert
        
        let level = Level(tasksCompleted: 0)
        let tasksCompletedLabel = "\(level.tasksCompleted)/\(level.nextLevel)\nTasks Completed"
        
        XCTAssertEqual(self.sut.header?.levelLabel.text, level.levelString)
        XCTAssertEqual(self.sut.header?.tasksCompletedLabel.text, tasksCompletedLabel)
        
    }
    
}
