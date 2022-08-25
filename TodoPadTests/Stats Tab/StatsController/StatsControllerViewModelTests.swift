//
//  StatsControllerViewModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-25.
//

import XCTest
@testable import TodoPad

class StatsControllerViewModelTests: XCTestCase {
    
    var sut: StatsControllerViewModel!

    override func setUpWithError() throws {
        let context = CoreDataTestStack().context
        
        let pTaskManager = PersistentTaskManager(context: context)
        let rTaskManager = RepeatingTaskManager(context: context)
        let nonRepTaskManager = NonRepeatingTaskManager(context: context)
        
        self.sut = StatsControllerViewModel(persistentTaskManager: pTaskManager, repeatingTaskManager: rTaskManager, nonRepeatingTaskManager: nonRepTaskManager)
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
}
