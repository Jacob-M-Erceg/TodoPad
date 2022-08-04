//
//  DateScrollerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import Foundation

class DateScrollerViewModel {
    
    enum SwipeDirection {
        case left
        case right
    }
    
    var onUpdate: (() -> Void)?
    
    private(set) var selectedDate: Date = Date()
    private(set) var currentSunday: Date
    
    init() {
        currentSunday = DateHelper.getSunday(for: selectedDate)
    }
    
    public func setSelectedDate(with selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    public func updateSunday(direction: SwipeDirection) {
        let newDate = DateHelper.addDays(currentSunday, offset: direction == .right ? -7 : 7)
        currentSunday = DateHelper.getSunday(for: newDate)
        self.onUpdate?()
    }
}
