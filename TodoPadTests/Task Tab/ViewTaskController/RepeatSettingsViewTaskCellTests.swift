//
//  RepeatSettingsViewTaskCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-18.
//

import XCTest
@testable import TodoPad

class RepeatSettingsViewTaskCellTests: XCTestCase {
    
    var sut: RepeatSettingsViewTaskCell!
    
    override func setUpWithError() throws {
        self.sut = RepeatSettingsViewTaskCell()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testRepeatSettingsViewTaskCell_WhenConfigured_PropertiesAreSet() {
        // Arrange
        let image = UIImage(systemName: "plus")
        let title = "My Title"
        let array = [1, 2, 5]
        
        // Act
        self.sut.configure(image: image, title: title, weekdayArray: array)
        
        // Assert
        XCTAssertEqual(self.sut.iconImageView.image, image)
        XCTAssertEqual(self.sut.titleLabel.text, title)
        XCTAssertEqual(self.sut.weekdayArray, array)
    }
    
    func testRepeatSettingsViewTaskCell_WhenConfiguredWithWeekdayArray_CollectionViewIsSetup() {
        // Arrange
        self.sut.configure(image: nil, title: "My Title", weekdayArray: [1, 2, 5])
        
        // Act
        let containsCollectionView = self.sut.subviews.contains(where: { $0 is UICollectionView })
        
        // Assert
        XCTAssertTrue(containsCollectionView, "A UICollectionView should have been added for weekday cells.")
    }
    
    func testRepeatSettingsViewTaskCell_WhenConfiguredWithoutWeekdayArray_CollectionViewIsNotSetup() {
        // Arrange
        self.sut.configure(image: nil, title: "My Title", weekdayArray: nil)
        
        // Act
        let containsCollectionView = self.sut.subviews.contains(where: { $0 is UICollectionView })
        
        // Assert
        XCTAssertFalse(containsCollectionView, "There should only be a UICollectionView when configured when a weekdayArray.")
    }
    
    func testRepeatSettingsViewTaskCell_NumberOfItemsInSection_Returns7() {
        // Arrange
        self.sut.configure(image: nil, title: "My Title", weekdayArray: [1, 2, 5])
        
        // Act
        let cellCount = self.sut.collectionView.dataSource?.collectionView(self.sut.collectionView, numberOfItemsInSection: 0)
        
        // Assert
        XCTAssertEqual(cellCount, 7)
    }
    
    func testRepeatSettingsViewTaskCell_CellForItemAt_ReturnsCell() {
        // Arrange
        self.sut.configure(image: nil, title: "My Title", weekdayArray: [1, 2, 5])
        
        // Act
        let cell = self.sut.collectionView.dataSource?.collectionView(self.sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? RepeatingDayCell
        
        // Assert
        XCTAssertEqual(cell?.label.text, "S", "The first cell should be 'S' for Sunday.")
        XCTAssertEqual(cell?.backgroundColor?.cgColor, UIColor.systemBlue.cgColor, "The background color should be blue because Sunday is selected (The 1 in the weekday array is for sunday).")
    }
    
    func testRepeatSettingsViewTaskCell_MinimumInteritemSpacingForSectionAt_Returns10() {
        // Arrange
        self.sut.configure(image: nil, title: "My Title", weekdayArray: [1, 2, 5])
        
        // Act
        let spacing = self.sut.collectionView(self.sut.collectionView, layout: UICollectionViewLayout(), minimumInteritemSpacingForSectionAt: 0)
        
        // Assert
        XCTAssertEqual(spacing, 10)
    }
}
