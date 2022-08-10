//
//  TaskFormRepeatSettingsCellViewModelk.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-10.
//

import UIKit

class TaskFormRepeatSettingsCellViewModel {
    
    private(set) var repeatSettings: RepeatSettings
    
    init(_ repeatSettings: RepeatSettings = .daily) {
        self.repeatSettings = repeatSettings
    }
    
    public func setRepeatSettings(_ repeatSettings: RepeatSettings) {
        self.repeatSettings = repeatSettings
    }
}

// MARK: - CollectionView
extension TaskFormRepeatSettingsCellViewModel {
    
    public func numberOfItemsInSection(for section: Int) -> Int {
        switch self.repeatSettings {
        case .weekly(_):
            return 7
        case .daily, .monthly, .yearly:
            return 0
        }
    }
    
    public func isDaySelected(for indexPath: IndexPath, _ weeklyArray: [Int]) -> Bool {
        return weeklyArray.contains(indexPath.row+1)
    }
    
    public func sizeForItemAt(viewWidth: CGFloat) -> CGSize {
        if viewWidth < ((37.5*7)+(10*6)) {
            return CGSize(width: 32.5, height: 32.5)
        }
        return CGSize(width: 37.5, height: 37.5)
    }
    
    public func insetForSectionAt(viewWidth: CGFloat, collectionViewWidth: CGFloat, collectionViewHeight: CGFloat) -> UIEdgeInsets {
        var cellWidth: CGFloat = 37.5
        var spacingWidth: CGFloat = 10

        if viewWidth < ((37.5*7)+(10*6)) {
            cellWidth = 32.5
            spacingWidth = 4
        }

        let totalCellWidth: CGFloat = cellWidth * 7
        let totalSpacingWidth: CGFloat = spacingWidth * 6

        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        let topInset = (collectionViewHeight - CGFloat(cellWidth)) / 2
        let bottomInset = topInset

        return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    public func minimumInteritemSpacingForSectionAt(viewWidth: CGFloat) -> CGFloat {
        if viewWidth < ((37.5*7)+(10*6)) {
            return 4
        }
        return 10
    }
    
    public func didSelectItemAt(_ indexPath: IndexPath) {
        
        switch self.repeatSettings {
        case .daily, .monthly, .yearly:
            break

        case .weekly(var weeklyArray):
            let dayAlreadySelected = self.isDaySelected(for: indexPath, weeklyArray)

            if dayAlreadySelected {
                weeklyArray.removeAll(where: { $0 == indexPath.row+1 })
            } else {
                weeklyArray.append(indexPath.row+1)
                weeklyArray.sort()
            }
            
            self.setRepeatSettings(RepeatSettings.weekly(weeklyArray))
        }
    }
}
