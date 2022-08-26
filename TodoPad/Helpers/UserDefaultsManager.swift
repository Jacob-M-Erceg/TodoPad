//
//  UserDefaultsManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-26.
//

import Foundation

class UserDefaultsManager {
    
    let statsSortingOptionsIsAscendingKey: String
    let statsSortingOptionsSortByKey: String
    
    init(
        _ statsSortingOptionsIsAscendingKey: String = Constants.statsSortingOptionsIsAscendingKey,
        _ statsSortingOptionsSortByKey: String = Constants.statsSortingOptionsSortByKey
    ) {
        self.statsSortingOptionsIsAscendingKey = statsSortingOptionsIsAscendingKey
        self.statsSortingOptionsSortByKey = statsSortingOptionsSortByKey
    }

    func setStatControllerSortingOptions(with statControllerSortOptions: StatsControllerSortingOptions) {
        let defaults = UserDefaults.standard
        defaults.setValue(statControllerSortOptions.isAscending, forKey: statsSortingOptionsIsAscendingKey)
        defaults.setValue(statControllerSortOptions.sortBy.rawValue, forKey: statsSortingOptionsSortByKey)
    }
    
    var getStatsControllerSortingOptions: StatsControllerSortingOptions {
        guard let isAscending = UserDefaults.standard.object(forKey: statsSortingOptionsIsAscendingKey) as? Bool,
              let sortByString = UserDefaults.standard.string(forKey: statsSortingOptionsSortByKey),
              let sortBy = StatsControllerSortingOptions.SortBy(rawValue: sortByString)
        else {
            return StatsControllerSortingOptions(isAscending: true, sortBy: .timeOfDay)
        }
        
        return StatsControllerSortingOptions(isAscending: isAscending, sortBy: sortBy)
    }
}
