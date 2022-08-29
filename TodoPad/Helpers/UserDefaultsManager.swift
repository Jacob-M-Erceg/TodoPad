//
//  UserDefaultsManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-26.
//

import Foundation

class UserDefaultsManager {
    
    private let statsSortingOptionsIsAscendingKey: String
    private let statsSortingOptionsSortByKey: String
    
    private static let lastAskedForAppReviewKey = Constants.lastAskedForAppReviewKey
    private static let ratedAppAlreadyKey = Constants.ratedAppAlreadyKey
    
    init(
        _ statsSortingOptionsIsAscendingKey: String = Constants.statsSortingOptionsIsAscendingKey,
        _ statsSortingOptionsSortByKey: String = Constants.statsSortingOptionsSortByKey
        
    ) {
        self.statsSortingOptionsIsAscendingKey = statsSortingOptionsIsAscendingKey
        self.statsSortingOptionsSortByKey = statsSortingOptionsSortByKey
    }

    // MARK: - StatsController Sorting Options
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
    
    // MARK: - Ask For App Rating
    static func setLastAskedForReviewDate() {
        UserDefaults.standard.set(Date(), forKey: self.lastAskedForAppReviewKey)
    }
    
    static func getLastAskedForReviewDate() -> Date? {
        if let lastAskedForReviewDate = UserDefaults.standard.object(forKey: self.lastAskedForAppReviewKey) as? Date {
            return lastAskedForReviewDate
        } else {
            return nil
        }
    }
    
    static func setRatedAppAlreadyTrue() {
        UserDefaults.standard.set(true, forKey: self.ratedAppAlreadyKey)
        
    }
    
    static func getRatedAppAlreadyValue() -> Bool {
        var ratedAppAlready = false
        
        if let ratedAlreadyUserDefaults = UserDefaults.standard.object(forKey: self.ratedAppAlreadyKey) as? Bool {
            ratedAppAlready = ratedAlreadyUserDefaults
        }
        
        return ratedAppAlready
    }
}
