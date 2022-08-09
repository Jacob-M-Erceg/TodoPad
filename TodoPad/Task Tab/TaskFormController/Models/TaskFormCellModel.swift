//
//  TaskFormCellModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-07.
//

import UIKit

/// The model for task form cells. It holds data like what kind of cell it is, the icon for the cell, and if the cell is enabled or expanded.
struct TaskFormCellModel: Equatable {
    
    enum CellType {
        case title
        case description
        case startDate
        case time
        case repeats
        case endDate
        case notifications
        
        var isExpandable: Bool {
            switch self {
            case .title, .description:
                return false
            case .startDate, .time, .endDate, .repeats, .notifications:
                return true
            }
        }
    }
    
    // MARK: - Variables
    let cellType: CellType
    /// Non-Optional cells are always enabled, Optional cells can be switched off and on.
    private(set) var isEnabled: Bool
    /// Whether the cell is expanded or not
    private(set) var isExpanded: Bool = false
    
    
    // MARK: - Initializer
    init(cellType: CellType) {
        self.cellType = cellType
        
        switch cellType {
        case .title, .description:
            self.isEnabled = true
            
        case .startDate, .time, .repeats, .endDate, .notifications:
            self.isEnabled = false
        }
    }
    
}


// MARK: - Computed Properties
extension TaskFormCellModel {
    
    var icon: UIImage? {
        switch self.cellType {
        case .title, .description:
            return nil
        case .startDate, .endDate:
            return UIImage(systemName: "calendar")
        case .time:
            return  UIImage(systemName: "clock")
        case .repeats:
            return UIImage(systemName: "repeat")
        case .notifications:
            return UIImage(systemName: "bell")
        }
    }
    
    var title: String {
        switch self.cellType {
        case .title:
            return "Title"
        case .description:
            return "Description"
        case .startDate:
            return "Date"
        case .time:
            return "Time"
        case .repeats:
            return "Repeating"
        case .endDate:
            return "End Date"
        case .notifications:
            return "Notifications"
        }
    }
}


// MARK: - Setters
extension TaskFormCellModel {
    
    public mutating func setIsEnabled(isEnabled: Bool) {
        switch self.cellType {
        case .title, .description:
            self.isEnabled = true
            
        case .startDate, .time, .repeats, .endDate, .notifications:
            self.isEnabled = isEnabled
        }
    }
    
    public mutating func setIsExpanded(isExpanded: Bool) {
        switch self.cellType {
        case .title, .description:
            return
            
        case .startDate, .time, .repeats, .endDate, .notifications:
            self.isExpanded = isExpanded
        }
    }
}
