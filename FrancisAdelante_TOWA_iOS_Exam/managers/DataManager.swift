//
//  DataManager.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/13/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Foundation
import CoreData

public struct KeyValuePair {
    var key = ""
    var value: AnyObject
}

class DataManager: NSObject {
    static let shared = DataManager()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "FrancisAdelante_TOWA_iOS_Exam", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("FrancisAdelanteGreatFeat")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func fetchObjects(entityName: String!, keyValuePair: KeyValuePair? = nil) -> [AnyObject]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        if let keyValuePair = keyValuePair {
            if let value = keyValuePair.value as? String {
                fetchRequest.predicate = NSPredicate(format: "\(keyValuePair.key) = %@", argumentArray: [value])
            } else if let value = keyValuePair.value as? NSNumber {
                fetchRequest.predicate = NSPredicate(format: keyValuePair.key + " = " + String(describing: value))
            }
        }
        
        var objects: [AnyObject]?
        do {
            objects = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        guard objects != nil else {
            return nil
        }
        guard objects!.count > 0 else {
            return nil
        }
        
        return objects
    }
    
    func fetchObject(entityName: String!, keyValuePair: KeyValuePair? = nil) -> NSManagedObject? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        if let keyValuePair = keyValuePair {
            if let value = keyValuePair.value as? String {
                fetchRequest.predicate = NSPredicate(format: "\(keyValuePair.key) = %@", argumentArray: [value])
            } else if let value = keyValuePair.value as? NSNumber {
                fetchRequest.predicate = NSPredicate(format: keyValuePair.key + " = " + String(describing: value))
            }
        }
        
        var objects: [AnyObject]?
        do {
            objects = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        guard objects != nil else {
            return nil
        }
        guard objects!.count > 0 else {
            return nil
        }
        
        return objects?.first as? NSManagedObject
    }
    
    func fetchObject(entityName: String!, predicate: NSPredicate? = nil) -> NSManagedObject? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        var objects: [AnyObject]?
        do {
            objects = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        guard objects != nil else {
            return nil
        }
        guard objects!.count > 0 else {
            return nil
        }
        
        return objects?.first as? NSManagedObject
    }
    
    func saveChanges() {
        do {
            try managedObjectContext.save()
        } catch let error {
            fatalError("Failure to save context: \(error)")
        }
    }
}
