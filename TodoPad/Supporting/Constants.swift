//
//  Constants.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import Foundation

func devPrint(_ items: Any...) {
    if Constants.inDevelopment {
        print("PRINT DEBUG:", items)
    }
}

class Constants {
    static let inDevelopment = true
    
    static let weekdaysArray: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    static let weekdayLettersArray: [String] = ["S", "M", "T", "W", "T", "F", "S"]
    
    static let repeatSettingsTitles = [
        "Daily",
        "Weekly",
        "Monthly",
        "Yearly"
    ]
    
    // MARK: - User Defaults Keys
    static let statsSortingOptionsIsAscendingKey = "stats_sorting_options_is_ascending"
    static let statsSortingOptionsSortByKey = "stats_sorting_options_sort_by"
    
    static let statsSortingOptionsIsAscendingKeyTesting = statsSortingOptionsIsAscendingKey + "_testing"
    static let statsSortingOptionsSortByKeyTesting = statsSortingOptionsSortByKey + "_testing"
    
    
    // MARK: - Links
    static let privacyPolicy = "https://todopad.app/privacy-policy"
    static let termsAndConditions = "https://todopad.app/terms-and-conditions"
}
