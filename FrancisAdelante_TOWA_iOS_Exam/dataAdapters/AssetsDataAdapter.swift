//
//  AssetsDataAdapter.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/18/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

import UIKit
import CoreData
protocol DataAdapter {
    
    func performFetch() -> Int
    var predicate: NSPredicate? { get set }
    var sortDescriptors: [NSSortDescriptor]? { get set }
    
}

class AssetsDataAdapter: NSObject {
    var cachedCount = 0
    
    func performFetch() -> Int {
        do {
            try fetchedResultsController?.performFetch()
            guard let count = fetchedResultsController?.fetchedObjects?.count else {
                cachedCount = 0
                return 0
            }
            cachedCount = count
            return count
        } catch {
            
        }
        return 0
    }
    
    lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult>? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = Asset
            .entityDescriptionWithContext(context: DataManager.shared.managedObjectContext)
        fetchRequest.sortDescriptors = sortDescriptors ?? [NSSortDescriptor(key: "assetID", ascending: true)]
        fetchRequest.predicate = self.predicate
        return fetchRequest
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest!,
                                                                  managedObjectContext: DataManager.shared.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    var predicate: NSPredicate? {
        didSet {
            fetchRequest?.predicate = predicate
        }
    }
    var sortDescriptors: [NSSortDescriptor]? {
        didSet {
            fetchRequest?.sortDescriptors = sortDescriptors
        }
    }
}

extension AssetsDataAdapter: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("")
    }
    
}

extension AssetsDataAdapter: AssetsListViewDataSource {
    func assetsListView(numberOfObjects assetsListView: AssetsView) -> Int {
        return performFetch()
    }
    
    func assetsListView(newsObject assetstListView: AssetsView, objectAt indexPath: IndexPath) -> Asset? {
        return fetchedResultsController?.object(at: indexPath) as? Asset
    }
    
}
