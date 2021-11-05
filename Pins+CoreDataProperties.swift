//
//  Pins+CoreDataProperties.swift
//  
//
//  Created by Christopher DeMaio on 11/3/21.
//
//

import Foundation
import CoreData


extension Pins {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pins> {
        return NSFetchRequest<Pins>(entityName: "Pins")
    }

    @NSManaged public var lat: Double
    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var tag: String?
    @NSManaged public var public: Bool
    @NSManaged public var creator: String?
    @NSManaged public var lon: Double

}
