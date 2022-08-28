//
//  StatsControllerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-25.
//

import Foundation

class StatsControllerViewModel {
    
    var onUpdate: (()->Void)?
    
    // MARK: - Managers
    private(set) var persistentTaskManager: PersistentTaskManager
    private(set) var repeatingTaskManager: RepeatingTaskManager
    private(set) var nonRepeatingTaskManager: NonRepeatingTaskManager
    private(set) var userDefaultsManager: UserDefaultsManager
    
    // MARK: - Variables
    private(set) var repeatingTasks: [RepeatingTaskStats] = []
    private(set) lazy var sortingOptions: StatsControllerSortingOptions = userDefaultsManager.getStatsControllerSortingOptions
    
    // MARK: - Initalizer
    init(
        persistentTaskManager: PersistentTaskManager = PersistentTaskManager(),
        repeatingTaskManager: RepeatingTaskManager = RepeatingTaskManager(),
        nonRepeatingTaskManager: NonRepeatingTaskManager = NonRepeatingTaskManager(),
        userDefaultsManager: UserDefaultsManager = UserDefaultsManager()
    ) {
        self.persistentTaskManager = persistentTaskManager
        self.repeatingTaskManager = repeatingTaskManager
        self.nonRepeatingTaskManager = nonRepeatingTaskManager
        self.userDefaultsManager = userDefaultsManager
        
        self.fetchData()
    }
    
    // MARK: - Fetching Data
    public func fetchData() {
        self.fetchRepeatingTasks()
        self.sortRepeatingTasks()
        self.onUpdate?()
    }
    
    private func fetchRepeatingTasks() {
        self.repeatingTasks = repeatingTaskManager.fetchAllRepeatingTasks().map({ [weak self] in
            guard let self = self else {
                fatalError("StatsControllerViewModel.fetchData fatalerror")
            }
            let daysCompleted = self.repeatingTaskManager.fetchRepeatingTaskCompletedCount(for: $0)
            return RepeatingTaskStats(repeatingTask: $0, daysCompleted: daysCompleted)
        })
    }
    
    private func sortRepeatingTasks() {
        self.repeatingTasks.sort(by: { [weak self] task1, task2 in
            guard let self = self else { return true }
            
            if self.sortingOptions.isAscending {
                
                switch self.sortingOptions.sortBy {
                case .name:
                    return task1.repeatingTask.title < task2.repeatingTask.title
                    
                    case .timeOfDay:
                    return (task1.repeatingTask.time?.comparableByTime ?? Date().endOfDay!) < (task2.repeatingTask.time?.comparableByTime ?? Date().endOfDay!)
                    
                case .ratio:
                    let task1Ratio = Float(task1.daysCompleted) / Float(task1.daysSinceStarted)
                    let task2Ratio = Float(task2.daysCompleted) / Float(task2.daysSinceStarted)
                    return task1Ratio < task2Ratio
                    
                case .daysCompleted:
                    return task1.daysCompleted < task2.daysCompleted
                }
                
            } else {
                
                switch self.sortingOptions.sortBy {
                case .name:
                    return task1.repeatingTask.title > task2.repeatingTask.title
                    
                case .timeOfDay:
                    return (task1.repeatingTask.time?.comparableByTime ?? Date().endOfDay!) > (task2.repeatingTask.time?.comparableByTime ?? Date().endOfDay!)
                    
                case .ratio:
                    let task1Ratio = Float(task1.daysCompleted) / Float(task1.daysSinceStarted)
                    let task2Ratio = Float(task2.daysCompleted) / Float(task2.daysSinceStarted)
                    return task1Ratio > task2Ratio
                    
                case .daysCompleted:
                    return task1.daysCompleted > task2.daysCompleted
                }
            }
        })
    }
    
    public func fetchTotalTasksCompletedCount() -> Int {
        var count = 0
        
        count += persistentTaskManager.fetchCompletedPersistentTaskCount()
        count += nonRepeatingTaskManager.fetchCompletedNonRepeatingTaskCount()
        self.repeatingTasks.forEach({ count += $0.daysCompleted })
        
        return count
    }
}


// MARK: - Set Sorting Options
extension StatsControllerViewModel {
    
    public func setSortingOptions(with sortBy: StatsControllerSortingOptions.SortBy) {
        HapticsManager.shared.vibrateForActionCompleted()
        
        if self.sortingOptions.sortBy == sortBy {
            // Invert Ascending/Descending
            self.sortingOptions.setIsAscending(with: !self.sortingOptions.isAscending)
        } else {
            // Change Sort By Option
            self.sortingOptions.setSortBy(with: sortBy)
        }
        
        self.userDefaultsManager.setStatControllerSortingOptions(with: self.sortingOptions)
        
        self.fetchData()
        self.onUpdate?()
    }
}
