//
//  RepeatSettingsCD+CoreDataProperties.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//
//

import Foundation
import CoreData


extension RepeatSettingsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepeatSettingsCD> {
        return NSFetchRequest<RepeatSettingsCD>(entityName: "RepeatSettingsCD")
    }

    @NSManaged public var peroid: Int16
    @NSManaged public var days: [NSInteger]
    @NSManaged public var task: RepeatingTaskCD

}

extension RepeatSettingsCD : Identifiable {

}
