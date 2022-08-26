//
//  Double+Extensions.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-26.
//

import Foundation

extension Double {
    func roundTo(decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}
