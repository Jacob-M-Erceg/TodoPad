//
//  RepeatSettingsCD+CoreDataClass.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//
//

import Foundation
import CoreData

@objc(RepeatSettingsCD)
public class RepeatSettingsCD: NSManagedObject {

    convenience init(_ context: NSManagedObjectContext,
                     _ repeatSettings: RepeatSettings, _ repeatingTask: RepeatingTaskCD) {
        self.init(context: context)
        self.task = repeatingTask
        self.days = []
        
        switch repeatSettings {
        case .daily:
            self.peroid = 0
            
        case .weekly(let array):
            self.peroid = 1
            self.days = array
            
        case .monthly:
            self.peroid = 2
            
        case .yearly:
            self.peroid = 3
        }
    }
    
    func update(_ repeatSettings: RepeatSettings) {
        self.days = []

        switch repeatSettings {
        case .daily:
            self.peroid = 0

        case .weekly(let array):
            self.peroid = 1
            self.days = array

        case .monthly:
            self.peroid = 2

        case .yearly:
            self.peroid = 3
        }
    }
}
