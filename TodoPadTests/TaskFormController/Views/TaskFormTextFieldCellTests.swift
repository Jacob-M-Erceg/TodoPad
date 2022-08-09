//
//  TaskFormTextFieldCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-08.
//

import XCTest
@testable import TodoPad

class TaskFormTextFieldCellTests: XCTestCase {
    
    var sut: TaskFormTextFieldCell!

    override func setUpWithError() throws {
        self.sut = TaskFormTextFieldCell()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testTaskFormTextFieldCell_WhenConfiguredWithNilTextFieldText_TextFieldTextIsNil() {
        // Arrange
        self.sut.configure(with: .init(cellType: .title), textFieldText: nil)
        
        // Assert
        XCTAssertEqual(self.sut.textField.text, "", "TextField Text should be an empty string since nil was passed into configure.")
    }
    
    func testTaskFormTextFieldCell_WhenConfiguredWithNilTextFieldText_TextFieldTextIsCorrect() {
        // Arrange
        self.sut.configure(with: .init(cellType: .description), textFieldText: "My Title")
        
        // Assert
        XCTAssertEqual(self.sut.textField.text, "My Title", "TextField Text should be an empty string since nil was passed into configure.")
    }
    
    func testTaskFormTextFieldCell_WhenConfiguredForTitle_TextFieldPlaceHolderIsTitle() {
        // Arrange
        self.sut.configure(with: .init(cellType: .title), textFieldText: nil)
        
        // Assert
        XCTAssertEqual(self.sut.textField.placeholder, "Title")
    }
    
    func testTaskFormTextFieldCell_WhenConfiguredForDescription_TextFieldPlaceHolderIsDescription() {
        // Arrange
        self.sut.configure(with: .init(cellType: .description), textFieldText: nil)
        
        // Assert
        XCTAssertEqual(self.sut.textField.placeholder, "Description")
    }
    
    func testTaskFormTextFieldCell_TextFieldChanged_DelegateFunctionCalled() {
        // Arrange
        sut.configure(with: .init(cellType: .title), textFieldText: "My Title")
        let mockDelegate = MockTaskFormTextFieldCellDelegate(testCase: self)
        sut.delegate = mockDelegate
        
        // Act
        mockDelegate.expectString()
        self.sut.textField.insertText("Some_text")
        
        // Assert
        XCTAssertEqual(self.sut.textField.text, mockDelegate.string, "Textfield String is not the same as the String passed back through delegate.")
        waitForExpectations(timeout: 1)
    }
}
