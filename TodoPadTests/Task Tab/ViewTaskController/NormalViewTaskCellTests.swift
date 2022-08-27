//
//  NormalViewTaskCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-18.
//

import XCTest
@testable import TodoPad

class NormalViewTaskCellTests: XCTestCase {
    
    var sut: NormalViewTaskCell!

    override func setUpWithError() throws {
        self.sut = NormalViewTaskCell()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testNormalViewTaskCell_WhenConfigured_UIImageIsSet() {
        // Arrange
        let image = UIImage(systemName: "plus")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        // Act
        self.sut.configure(image: image, title: "")
        
        // Assert
        XCTAssertEqual(self.sut.iconImageView.image, image)
    }
    
    func testNormalViewTaskCell_WhenConfigured_TitleLabelIsSet() {
        // Arrange
        let title = "My Title"
        
        // Act
        self.sut.configure(image: nil, title: title)
        
        // Assert
        XCTAssertEqual(self.sut.titleLabel.text, title)
    }

}
