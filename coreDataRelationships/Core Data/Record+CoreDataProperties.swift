//
//  Record+CoreDataProperties.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var year: String?
    @NSManaged public var month: String?
    @NSManaged public var customer: NSSet?

   public var customerArray: [Customer] {
       let set = customer as? Set<Customer> ?? []
       return set.sorted {
         $0.name ?? "" < $1.name ?? ""
       }
   }



}

// MARK: Generated accessors for customer
extension Record {

    @objc(addCustomerObject:)
    @NSManaged public func addToCustomer(_ value: Customer)

    @objc(removeCustomerObject:)
    @NSManaged public func removeFromCustomer(_ value: Customer)

    @objc(addCustomer:)
    @NSManaged public func addToCustomer(_ values: NSSet)

    @objc(removeCustomer:)
    @NSManaged public func removeFromCustomer(_ values: NSSet)

}

extension Record : Identifiable {

}
