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
}
