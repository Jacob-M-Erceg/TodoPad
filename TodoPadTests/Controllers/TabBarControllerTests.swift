//
//  TabBarControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-02.
//

import XCTest
@testable import TodoPad

class TabBarControllerTests: XCTestCase {
    
    var sut: TabBarController!

    override func setUpWithError() throws {
        sut = TabBarController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTabBarController_viewDidLoad_TabsCreated() {
        let tasksTab = sut.tabBar.items?[0]
        let statsTab = sut.tabBar.items?[1]
        
        XCTAssertEqual(tasksTab?.title, "Tasks")
        XCTAssertEqual(statsTab?.title, "Stats")
        
        XCTAssertEqual(tasksTab?.image, UIImage(systemName: "list.bullet"))
        XCTAssertEqual(statsTab?.image, UIImage(systemName: "chart.bar.fill"))
    }
    
}
