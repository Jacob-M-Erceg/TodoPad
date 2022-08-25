//
//  StatsControllerViewModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-25.
//

import Foundation

class StatsControllerViewModel {
    
//    var onUpdate: (()->Void)?
    
    private(set) var persistentTaskManager: PersistentTaskManager
    private(set) var repeatingTaskManager: RepeatingTaskManager
    private(set) var nonRepeatingTaskManager: NonRepeatingTaskManager
    
    init(
        persistentTaskManager: PersistentTaskManager = PersistentTaskManager(),
        repeatingTaskManager: RepeatingTaskManager = RepeatingTaskManager(),
        nonRepeatingTaskManager: NonRepeatingTaskManager = NonRepeatingTaskManager()
    ) {
        self.persistentTaskManager = persistentTaskManager
        self.repeatingTaskManager = repeatingTaskManager
        self.nonRepeatingTaskManager = nonRepeatingTaskManager
        
//        self.fetchData()
    }
    
//    public func fetchTotalTasksCompletedCount() -> Int {
//        var count = 0
//        
//        count += persistentTaskManager.fetchCompletedPersistentTaskCount()
//        count += nonRepeatingTaskManager.fetchCompletedNonRepeatingTaskCount()
//        self.repeatingTasks.forEach({ count += $0.daysCompleted })
//        
//        return count
//    }
}
