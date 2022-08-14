//
//  RepeatingTaskCD+CoreDataProperties.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//
//

import Foundation
import CoreData


extension RepeatingTaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepeatingTaskCD> {
        return NSFetchRequest<RepeatingTaskCD>(entityName: "RepeatingTaskCD")
    }

    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var startDate: Date
    @NSManaged public var time: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var taskUUID: UUID
    @NSManaged public var repeatSettings: RepeatSettingsCD
    @NSManaged public var notificationsEnabled: Bool
}

extension RepeatingTaskCD : Identifiable {

}
