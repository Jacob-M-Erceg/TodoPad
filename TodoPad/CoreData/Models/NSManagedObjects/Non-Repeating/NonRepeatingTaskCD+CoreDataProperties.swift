//
//  NonRepeatingTaskCD+CoreDataProperties.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-13.
//
//

import Foundation
import CoreData


extension NonRepeatingTaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NonRepeatingTaskCD> {
        return NSFetchRequest<NonRepeatingTaskCD>(entityName: "NonRepeatingTaskCD")
    }

    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var taskUUID: UUID
    @NSManaged public var isCompleted: Bool
    @NSManaged public var date: Date
    @NSManaged public var time: Date?
    @NSManaged public var notificationsEnabled: Bool

}

extension NonRepeatingTaskCD : Identifiable {

}
