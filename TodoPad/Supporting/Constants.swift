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
}
