//
//  BaseTaskFormDropDownCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-08.
//

import XCTest
@testable import TodoPad

class BaseTaskFormDropDownCellTests: XCTestCase {
    
    var sut: BaseTaskFormDropDownCell!
    
    override func setUpWithError() throws {
        self.sut = BaseTaskFormDropDownCell()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testBaseTaskFormDropDownCell_WhenConfigured_CorrectImageAndTitle() {
        // Arrange
        let taskFormCellModel = TaskFormCellModel.init(cellType: .notifications)
        self.sut.configure(with: taskFormCellModel)
        
        // Assert
        XCTAssertEqual(taskFormCellModel.icon, self.sut.iconImageView.image)
        XCTAssertEqual(taskFormCellModel.title, self.sut.titleLabel.text)
        XCTAssertEqual(taskFormCellModel.isEnabled, self.sut.onOffSwitch.isOn)
    }
    
    
    func testBaseTaskFormDropDownCell_WhenOnOffSwitchChanged_DelegateFunctionCalled() {
        // Arrange
        self.sut.configure(with: .init(cellType: .startDate))
        let mockDelegate = MockBaseTaskFormDropDownCellDelegate(testCase: self)
        self.sut.baseDelegate = mockDelegate
        
        // Act
        mockDelegate.expectIsEnabledBoolean()
        self.sut.onOffSwitch.sendActions(for: .valueChanged)
        
        // Assert
        XCTAssertEqual(self.sut.onOffSwitch.isOn, mockDelegate.isEnabled, "onOffSwitch Bool is not the same as the Bool passed back through delegate.")
        waitForExpectations(timeout: 1)
    }
    
}
