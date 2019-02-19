//
//  Asset+CoreDataProperties.swift
//  
//
//  Created by Francis Adelante on 2/15/19.
//
//

import Foundation
import CoreData

extension Asset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Asset> {
        return NSFetchRequest<Asset>(entityName: "Asset")
    }

    @NSManaged public var assetImg: String?
    @NSManaged public var assetType: String?
    @NSManaged public var assetClass: String?
    @NSManaged public var assetSubClass: String?
    @NSManaged public var assetLabel: String?
    @NSManaged public var assetFloor: String?
    @NSManaged public var assetIsInactive: Bool
    @NSManaged public var assetID: String?
    @NSManaged public var assetNote: String?

}

