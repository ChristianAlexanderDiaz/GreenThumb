//
//  Persistence.swift
//  Videos
//
//  Created by Christian Alexander Diaz on 3/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//  Tutorial by Osman Balci.
//

import CoreData

/**
 The `PersistenceController` struct creates and manages the Core Data stack for the app, including the `NSPersistentContainer` and `NSManagedObjectContext`.
 
 - Properties:
    - `shared`: The struct variable holding the instance reference of the newly created `PersistenceController` instance. It is referenced in any project file as `PersistenceController.shared`.
    - `persistentContainer`: The `NSPersistentContainer` instance used to hold the persistent stores for the app.
 
 - Functions:
    - `init(inMemory:)`: Initializes a new instance of `PersistenceController`. Sets up the persistent container with the `Videos` data model, and loads the persistent stores.
    - `saveContext()`: Saves changes made to the Core Data database.
 */
struct PersistenceController {
    static let shared = PersistenceController()
    let persistentContainer: NSPersistentContainer

    /**
     Initializes a new instance of `PersistenceController`. Sets up the persistent container with the `Videos` data model, and loads the persistent stores.
     
     - Parameters:
        - inMemory: A boolean value indicating whether to use an in-memory store. Defaults to `false`.
     */
    init(inMemory: Bool = false) {
        
        persistentContainer = NSPersistentContainer(name: "GreenThumb")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    /**
     A function `saveContext` that saves changes made to the Core Data database.
     */
    func saveContext () {
        let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.persistentContainer.viewContext
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
