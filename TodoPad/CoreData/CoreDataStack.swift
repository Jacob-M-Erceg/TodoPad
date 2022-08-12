//
//  CoreDataStack.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-12.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TodoPad")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved NSPersistentContainer error \(error), \(error.userInfo)")
            }
        }
        
        context = persistentContainer.viewContext
    }
}
