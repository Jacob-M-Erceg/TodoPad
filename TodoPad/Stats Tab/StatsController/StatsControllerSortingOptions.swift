//
//  StatsControllerSortingOptions.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-25.
//

import Foundation

struct StatsControllerSortingOptions {

    enum SortBy: String {
        case name
        case timeOfDay
        case ratio
        case daysCompleted
    }

    private(set) var isAscending: Bool = true
    private(set) var sortBy: SortBy
}


extension StatsControllerSortingOptions {
    
    public mutating func setIsAscending(with isAscending: Bool) {
        self.isAscending = isAscending
    }
    
    public mutating func setSortBy(with sortBy: SortBy) {
        self.sortBy = sortBy
    }
}
