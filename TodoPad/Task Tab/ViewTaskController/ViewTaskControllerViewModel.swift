//
//  ViewTaskControllerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-17.
//

import UIKit

class ViewTaskControllerViewModel {
    
    let task: Task
    private(set) var viewTaskCells: [ViewTaskCellModel] = []
    
    init(task: Task) {
        self.task = task
        self.populateViewTaskCellModelArray()
    }
    
    private func populateViewTaskCellModelArray() {
        switch self.task {
        case .persistent(_):
            self.viewTaskCells = []
            break
            
        case .repeating(let repeatingTask):
            self.viewTaskCells.append(ViewTaskCellModel(title: "Started \(DateHelper.getMonthAndDayString(for: repeatingTask.startDate))", image: UIImage(systemName: "calendar")))

            self.viewTaskCells.append(ViewTaskCellModel(title: repeatingTask.time?.timeString ?? "Anytime", image: UIImage(systemName: "clock")))

            self.viewTaskCells.append(ViewTaskCellModel(title: repeatingTask.repeatSettings.repeatPeroidString, image: UIImage(systemName: "repeat"), weeklyArray: repeatingTask.repeatSettings.getWeeklyArray))

            if let endDate = repeatingTask.endDate {
                self.viewTaskCells.append(ViewTaskCellModel(title: "Ending \(DateHelper.getMonthAndDayString(for: endDate))", image: UIImage(systemName: "calendar")))
            }
            
        case .nonRepeating(let nonRepeatingTask):
            self.viewTaskCells.append(ViewTaskCellModel(title: DateHelper.getMonthAndDayString(for: nonRepeatingTask.date), image: UIImage(systemName: "calendar")))

            self.viewTaskCells.append(ViewTaskCellModel(title: nonRepeatingTask.time?.timeString ?? "Anytime", image: UIImage(systemName: "clock")))
        }
        
        if self.task.notificationsEnabled {
            self.viewTaskCells.append(ViewTaskCellModel(title: "Notifications Enabled", image: UIImage(systemName: "bell")))
        }
    }
}
