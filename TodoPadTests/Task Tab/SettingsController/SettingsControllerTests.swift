//
//  SettingsControllerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-22.
//

import XCTest
@testable import TodoPad

class SettingsControllerTests: XCTestCase {
    
    var sut: SettingsController!

    override func setUpWithError() throws {
        self.sut = SettingsController()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
}
