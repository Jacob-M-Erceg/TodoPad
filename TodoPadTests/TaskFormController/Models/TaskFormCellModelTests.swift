//
//  TaskFormCellModelTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-07.
//

import XCTest
@testable import TodoPad

class TaskFormCellModelTests: XCTestCase {
    
    var titleCell: TaskFormCellModel!
    var descCell: TaskFormCellModel!
    var startDateCell: TaskFormCellModel!
    var timeCell: TaskFormCellModel!
    var repeatsCell: TaskFormCellModel!
    var endDateCell: TaskFormCellModel!
    var notificationsCell: TaskFormCellModel!
    
    override func setUpWithError() throws {
        self.titleCell = TaskFormCellModel(cellType: .title)
        self.descCell = TaskFormCellModel(cellType: .description)
        self.startDateCell = TaskFormCellModel(cellType: .startDate)
        self.timeCell = TaskFormCellModel(cellType: .time)
        self.repeatsCell = TaskFormCellModel(cellType: .repeats)
        self.endDateCell = TaskFormCellModel(cellType: .endDate)
        self.notificationsCell = TaskFormCellModel(cellType: .notifications)
        
    }
    
    override func tearDownWithError() throws {
        self.titleCell = nil
        self.descCell = nil
        self.startDateCell = nil
        self.timeCell = nil
        self.repeatsCell = nil
        self.endDateCell = nil
        self.notificationsCell = nil
    }
    
    func testTaskFormCellModel_InitializeNonOptionalCells_isEnabledSetTrue() {
        XCTAssertTrue(self.titleCell.isEnabled)
        XCTAssertTrue(self.descCell.isEnabled)
    }
    
    func testTaskFormCellModel_InitializeOptionalCells_isEnabledSetFalse() {
        XCTAssertFalse(self.startDateCell.isEnabled)
        XCTAssertFalse(self.timeCell.isEnabled)
        XCTAssertFalse(self.repeatsCell.isEnabled)
        XCTAssertFalse(self.endDateCell.isEnabled)
        XCTAssertFalse(self.notificationsCell.isEnabled)
    }
    
    func testTaskFormCellModel_NonExpandableCells_IsExpandableRetunsFalse() {
        XCTAssertFalse(self.titleCell.cellType.isExpandable)
        XCTAssertFalse(self.descCell.cellType.isExpandable)
    }
    
    func testTaskFormCellModel_ExpandableCells_IsExpandableRetunsTrue() {
        XCTAssertTrue(self.startDateCell.cellType.isExpandable)
        XCTAssertTrue(self.timeCell.cellType.isExpandable)
        XCTAssertTrue(self.repeatsCell.cellType.isExpandable)
        XCTAssertTrue(self.endDateCell.cellType.isExpandable)
        XCTAssertTrue(self.notificationsCell.cellType.isExpandable)
    }
    
    func testTaskFormCellModel_NoIconCells_IconPropertyReturnsNil() {
        XCTAssertNil(self.titleCell.icon)
        XCTAssertNil(self.descCell.icon)
    }
    
    func testTaskFormCellModel_IconCells_IconPropertyCorrectUIImage() {
        XCTAssertEqual(self.startDateCell.icon, UIImage(systemName: "calendar"))
        XCTAssertEqual(self.timeCell.icon, UIImage(systemName: "clock"))
        XCTAssertEqual(self.repeatsCell.icon, UIImage(systemName: "repeat"))
        XCTAssertEqual(self.endDateCell.icon, UIImage(systemName: "calendar"))
        XCTAssertEqual(self.notificationsCell.icon, UIImage(systemName: "bell"))
    }
    
    func testTaskFormCellModel_TitlePropertyReturnsCorrectTitle() {
        XCTAssertEqual(self.titleCell.title, "Title")
        XCTAssertEqual(self.descCell.title, "Description")
        XCTAssertEqual(self.startDateCell.title, "Date")
        XCTAssertEqual(self.timeCell.title, "Time")
        XCTAssertEqual(self.repeatsCell.title, "Repeating")
        XCTAssertEqual(self.endDateCell.title, "End Date")
        XCTAssertEqual(self.notificationsCell.title, "Notifications")
    }
    
    func testTaskFormCellModel_SetIsEnabledFalseForAlwaysEnabledCells_AlwaysReturnsTrue() {
        // Assert
        self.titleCell.setIsEnabled(isEnabled: false)
        self.descCell.setIsEnabled(isEnabled: false)
        
        // Assert
        XCTAssertTrue(self.titleCell.isEnabled)
        XCTAssertTrue(self.descCell.isEnabled)
    }
    
    func testTaskFormCellModel_SetIsEnabledTrueForOptionallyEnabledCells_ReturnsTrue() {
        // Act
        self.startDateCell.setIsEnabled(isEnabled: true)
        self.timeCell.setIsEnabled(isEnabled: true)
        self.repeatsCell.setIsEnabled(isEnabled: true)
        self.endDateCell.setIsEnabled(isEnabled: true)
        self.notificationsCell.setIsEnabled(isEnabled: true)
        
        
        // Assert
        XCTAssertTrue(self.startDateCell.isEnabled)
        XCTAssertTrue(self.timeCell.isEnabled)
        XCTAssertTrue(self.repeatsCell.isEnabled)
        XCTAssertTrue(self.endDateCell.isEnabled)
        XCTAssertTrue(self.notificationsCell.isEnabled)
    }
    
    func testTaskFormCellModel_SetIsEnabledTrueThenFalseForOptionallyEnabledCells_ReturnsFalse() {
        // Arrange
        self.startDateCell.setIsEnabled(isEnabled: true)
        self.timeCell.setIsEnabled(isEnabled: true)
        self.repeatsCell.setIsEnabled(isEnabled: true)
        self.endDateCell.setIsEnabled(isEnabled: true)
        self.notificationsCell.setIsEnabled(isEnabled: true)
        
        self.startDateCell.setIsEnabled(isEnabled: false)
        self.timeCell.setIsEnabled(isEnabled: false)
        self.repeatsCell.setIsEnabled(isEnabled: false)
        self.endDateCell.setIsEnabled(isEnabled: false)
        self.notificationsCell.setIsEnabled(isEnabled: false)
        
        // Assert
        XCTAssertFalse(self.startDateCell.isEnabled)
        XCTAssertFalse(self.timeCell.isEnabled)
        XCTAssertFalse(self.repeatsCell.isEnabled)
        XCTAssertFalse(self.endDateCell.isEnabled)
        XCTAssertFalse(self.notificationsCell.isEnabled)
    }
    
    func testTaskFormCellModel_SetIsExpandedTrueForNonExpandableCells_AlwaysReturnsFalse() {
        // Assert
        self.titleCell.setIsExpanded(isExpanded: true)
        self.descCell.setIsExpanded(isExpanded: true)
        
        // Assert
        XCTAssertFalse(self.titleCell.isExpanded)
        XCTAssertFalse(self.descCell.isExpanded)
    }
    
    func testTaskFormCellModel_SetIsExpandedTrueForExpandableCells_ReturnsTrue() {
        // Act
        self.startDateCell.setIsExpanded(isExpanded: true)
        self.timeCell.setIsExpanded(isExpanded: true)
        self.repeatsCell.setIsExpanded(isExpanded: true)
        self.endDateCell.setIsExpanded(isExpanded: true)
        self.notificationsCell.setIsExpanded(isExpanded: true)
        
        // Assert
        XCTAssertTrue(self.startDateCell.isExpanded)
        XCTAssertTrue(self.timeCell.isExpanded)
        XCTAssertTrue(self.repeatsCell.isExpanded)
        XCTAssertTrue(self.endDateCell.isExpanded)
        XCTAssertTrue(self.notificationsCell.isExpanded)
    }
    
    func testTaskFormCellModel_SetIsExpandedTrueThenFalseForExpandableCells_ReturnsFalse() {
        // Arrange
        self.startDateCell.setIsExpanded(isExpanded: true)
        self.timeCell.setIsExpanded(isExpanded: true)
        self.repeatsCell.setIsExpanded(isExpanded: true)
        self.endDateCell.setIsExpanded(isExpanded: true)
        self.notificationsCell.setIsExpanded(isExpanded: true)
        
        self.startDateCell.setIsExpanded(isExpanded: false)
        self.timeCell.setIsExpanded(isExpanded: false)
        self.repeatsCell.setIsExpanded(isExpanded: false)
        self.endDateCell.setIsExpanded(isExpanded: false)
        self.notificationsCell.setIsExpanded(isExpanded: false)
        
        // Assert
        XCTAssertFalse(self.startDateCell.isExpanded)
        XCTAssertFalse(self.timeCell.isExpanded)
        XCTAssertFalse(self.repeatsCell.isExpanded)
        XCTAssertFalse(self.endDateCell.isExpanded)
        XCTAssertFalse(self.notificationsCell.isExpanded)
    }
}
