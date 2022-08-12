//
//  PersistentTaskCD+CoreDataProperties.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-12.
//
//

import Foundation
import CoreData


extension PersistentTaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistentTaskCD> {
        return NSFetchRequest<PersistentTaskCD>(entityName: "PersistentTaskCD")
    }
    
    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var taskUUID: UUID
    @NSManaged public var dateCompleted: Date?

}

extension PersistentTaskCD : Identifiable {

}
