//
//  TaskFormRepeatSettingsCellTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-09.
//

import XCTest
@testable import TodoPad

class TaskFormRepeatSettingsCellTests: XCTestCase {
    
    var sut: TaskFormRepeatSettingsCell!
    var enabledTaskFormCellModel: TaskFormCellModel!
    
    override func setUpWithError() throws {
        self.sut = TaskFormRepeatSettingsCell()
        
        self.enabledTaskFormCellModel = TaskFormCellModel(cellType: .repeats)
        self.enabledTaskFormCellModel.setIsEnabled(isEnabled: true)
        self.enabledTaskFormCellModel.setIsExpanded(isExpanded: true)
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
        self.enabledTaskFormCellModel = nil
    }
}


// MARK: - When Initialized & WhenConfigured
extension TaskFormRepeatSettingsCellTests {
    func testTaskFormRepeatSettingsCell_WhenInitalized_RepeatSettingsIsDaily() {
        // Assert
        XCTAssertEqual(self.sut.viewModel.repeatSettings, .daily, "RepeatSettings should be .daily at init before configure() has been called.")
    }
    
    func testTaskFormRepeatSettingsCell_WhenConfiguredWithDaily_RepeatSettingsIsDaily() {
        // Arrange
        self.sut.configure(with: TaskFormCellModel(cellType: .repeats), and: .daily)
        
        // Assert
        XCTAssertEqual(self.sut.viewModel.repeatSettings, .daily, "RepeatSettings was not .daily when it was configured to be.")
    }
    
    func testTaskFormRepeatSettingsCell_WhenConfiguredWithWeekly_RepeatSettingsIsWeekly() {
        // Arrange
        self.sut.configure(with: TaskFormCellModel(cellType: .repeats), and: .weekly([1, 4, 5]))
        
        // Assert
        XCTAssertEqual(self.sut.viewModel.repeatSettings, .weekly([1, 4, 5]), "RepeatSettings was not .weekly when it was configured to be.")
    }
    
    func testTaskFormRepeatSettingsCell_WhenConfiguredWithMonthly_RepeatSettingsIsMonthly() {
        // Arrange
        self.sut.configure(with: TaskFormCellModel(cellType: .repeats), and: .monthly)
        
        // Assert
        XCTAssertEqual(self.sut.viewModel.repeatSettings, .monthly, "RepeatSettings was not .monthly when it was configured to be.")
    }
    
    func testTaskFormRepeatSettingsCell_WhenConfiguredWithYearly_RepeatSettingsIsYearly() {
        // Arrange
        self.sut.configure(with: TaskFormCellModel(cellType: .repeats), and: .yearly)
        
        // Assert
        XCTAssertEqual(self.sut.viewModel.repeatSettings, .yearly, "RepeatSettings was not .yearly when it was configured to be.")
    }
}


// MARK: - PickerView
extension TaskFormRepeatSettingsCellTests {
    
    func testTaskFormRepeatSettingsCell_WhenConfigured_PickerViewOnCorrectRow() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .monthly)
        
        // Assert
        XCTAssertEqual(self.sut.pickerView.selectedRow(inComponent: 0), 2, "PickerView is not being set to the correct position when for repeatSettings when configure called.")
    }
    
    func testTaskFormRepeatSettingsCell_PickerView_HasOneComponent() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .monthly)
        
        // Assert
        let numberOfComponents = self.sut.pickerView.dataSource?.numberOfComponents(in: self.sut.pickerView)
        XCTAssertEqual(numberOfComponents, 1, "NumberOfComponents should be 1.")
    }
    
    func testTaskFormRepeatSettingsCell_PickerView_NumberOfRowsInComponentIsFour() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .monthly)
        
        // Assert
        let numberOfRowsInComponent = self.sut.pickerView.dataSource?.pickerView(self.sut.pickerView, numberOfRowsInComponent: 0)
        XCTAssertEqual(numberOfRowsInComponent, 4, "NumberOfRowsInComponent should be 4. (Constants.repeatSettingsTitles.count)")
    }
    
    func testTaskFormRepeatSettingsCell_PickerView_TitlesForRowsCorrect() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .monthly)
        
        // Act
        let title0 = self.sut.pickerView.delegate?.pickerView?(self.sut.pickerView, titleForRow: 0, forComponent: 0)
        let title1 = self.sut.pickerView.delegate?.pickerView?(self.sut.pickerView, titleForRow: 1, forComponent: 0)
        let title2 = self.sut.pickerView.delegate?.pickerView?(self.sut.pickerView, titleForRow: 2, forComponent: 0)
        let title3 = self.sut.pickerView.delegate?.pickerView?(self.sut.pickerView, titleForRow: 3, forComponent: 0)
        
        // Assert
        XCTAssertEqual(title0, "Daily", "Title for row Zero is not Daily.")
        XCTAssertEqual(title1, "Weekly", "Title for row One does not Weekly.")
        XCTAssertEqual(title2, "Monthly", "Title for row Two does not Monthly.")
        XCTAssertEqual(title3, "Yearly", "Title for row Three does not Yearly.")
    }
    
    func testTaskFormRepeatSettingsCell_PickerViewRowSelected_DelegateFunctionCalled() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .daily)
        
        let mockDelegate = MockTaskFormRepeatSettingsCellDelegate(testCase: self)
        self.sut.delegate = mockDelegate
        
        // Act
        mockDelegate.expectRepeatSettings()
        let selectedRow = 2
        self.sut.pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        self.sut.pickerView.delegate?.pickerView?(self.sut.pickerView, didSelectRow: selectedRow, inComponent: 0)
        
        
        // Assert
        waitForExpectations(timeout: 1)
        XCTAssertEqual(mockDelegate.repeatSettings, .init(number: self.sut.pickerView.selectedRow(inComponent: 0)), "The RepeatSettings variable passed through the delegate function does not match the RepeatSettings initialized with the DatePickers selectedRow")
    }
    
}


// MARK: - CollectionView
extension TaskFormRepeatSettingsCellTests {
    
    // MARK: - NumberOfItemsInSection
    func testTaskFormRepeatSettingsCell_WhenRepeatSettingsIsNotWeekly_NumberOfItemsInSectionIsZero() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .monthly)
        let itemCount = self.sut.collectionView.dataSource?.collectionView(self.sut.collectionView, numberOfItemsInSection: 0)
        
        // Assert
        XCTAssertEqual(itemCount, 0, "The CollectionView should only be populated when repeatSettings is .weekly")
    }
    
    func testTaskFormRepeatSettingsCell_WhenRepeatSettingsIsWeekly_NumberOfItemsInSectionIsSeven() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .weekly([]))
        let itemCount = self.sut.collectionView.dataSource?.collectionView(self.sut.collectionView, numberOfItemsInSection: 0)
        
        // Assert
        XCTAssertEqual(itemCount, 7, "There should be seven collectionView items when repeatSettings is .weekly")
    }
    
    // MARK: - CellForItemAt
    func testTaskFormRepeatSettingsCell_WhenRepeatSettingsIsNotWeekly_LabelTextShouldBeE() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .daily)
        let cell = self.sut.collectionView.dataSource?.collectionView(self.sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? RepeatingDayCell
        
        // Assert
        XCTAssertEqual(cell?.label.text, "E", "The labels text should be E (error) because only .weekly uses this collectionview.")
    }
    
    func testTaskFormRepeatSettingsCell_WhenRepeatSettingsIsWeekly_LabelTextShouldBeCorrect() {
        // Arrange
        self.sut.configure(with: self.enabledTaskFormCellModel, and: .weekly([1]))
        let sundayCell = self.sut.collectionView.dataSource?.collectionView(self.sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? RepeatingDayCell
        let mondayCell = self.sut.collectionView.dataSource?.collectionView(self.sut.collectionView, cellForItemAt: IndexPath(row: 1, section: 0)) as? RepeatingDayCell
        
        XCTAssertNotNil(sundayCell)
        XCTAssertNotNil(mondayCell, "RepeatingDayCell was not initialized when it should have been.")
    }
    
}
