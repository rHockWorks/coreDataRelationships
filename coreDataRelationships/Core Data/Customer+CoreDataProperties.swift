//
//  Customer+CoreDataProperties.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }
    @NSManaged public var name: String?
    @NSManaged public var age: Int32
    @NSManaged public var gender: String?
    @NSManaged public var country: String?
    @NSManaged public var record: Record?

}

extension Customer : Identifiable {

}
