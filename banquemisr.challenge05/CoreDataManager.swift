//
//  CoreDataManager.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 05/10/2024.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

