//
//  CoreDataTestStack.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-12.
//

import Foundation
import CoreData
@testable import TodoPad

struct CoreDataTestStack {
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TodoPad")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Testing: Unresolved NSPersistentContainer error \(error), \(error.userInfo)")
            }
        }
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.automaticallyMergesChangesFromParent = true
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
}
