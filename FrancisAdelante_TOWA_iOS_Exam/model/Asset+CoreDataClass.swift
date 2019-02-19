//
//  Asset+CoreDataClass.swift
//  
//
//  Created by Francis Adelante on 2/15/19.
//
//

import Foundation
import CoreData

public class Asset: NSManagedObject {
    
    @discardableResult static func assetsObjectWithData(assetsData: [String: AnyObject]) -> Asset? {
        
        let assetID = assetsData["_id"] as? String
        
        let keyValuePair = KeyValuePair(key: "assetID", value: assetID as AnyObject)
        var assetsObject = DataManager.shared.fetchObject(entityName: Asset.classNameAsString(), keyValuePair: keyValuePair) as? Asset
        if assetsObject == nil {
            assetsObject = Asset.createObjectInContext(context: DataManager.shared.managedObjectContext) as? Asset
            assetsObject?.assetID = assetID
        }
       
        if let classObject = assetsData["class"] as? [String: Any] {
            if let assetClass = classObject["name"] as? String {
                assetsObject?.assetClass = assetClass
            }
        }
        if let subClassObject = assetsData["subClass"] as? [String: Any] {
            if let assetSubClass = subClassObject["name"] as? String {
                assetsObject?.assetSubClass = assetSubClass
            }
        }
        
        if let floorObject = assetsData["floor"] as? [String: Any] {
            if let assetFloor = floorObject["name"] as? String {
                assetsObject?.assetFloor = assetFloor
            }
        }
        
        if let assetLabel = assetsData["label"] as? String {
            assetsObject?.assetLabel = assetLabel
        }
        
        if let assetNote = assetsData["notes"] as? String {
            assetsObject?.assetNote = assetNote
        }
        
        if let typeObject = assetsData["type"] as? [String: Any] {
            if let assetType = typeObject["name"] as? String {
                assetsObject?.assetType = assetType
            }
        }
        
        if let isInactive = assetsData["isInactive"] as? Bool {
            assetsObject?.assetIsInactive = isInactive
        }
        
        if let photoArray = assetsData["photos"] as? [[String: Any]] {
            let photoObject = photoArray[0] as [String: Any]
            if let photoURL = photoObject["url"] as? String {
                assetsObject?.assetImg = photoURL
            }
            
        }
        
        
        
        return assetsObject
    }
}
