//
//  DataManager.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//

import Foundation
import CoreData

class DataManager {
private class func getContext() -> NSManagedObjectContext {
  return PersistenceController.shared.container.viewContext
}

   class func fetchAllRecords() -> [Record] {
      print("Loading function: \(#function), line: \(#line) \(#fileID)")
      let context = getContext()
      var records = [Record]()
      let recordsFetchRequest: NSFetchRequest<Record> = Record.fetchRequest()

   do {
      records = try context.fetch(recordsFetchRequest) }
   catch {
      print (error)
   }
return records
   }

   class func newRecord(month: String, year: String) -> Record {
let context = getContext()

   print("Loading function: \(#function), line: \(#line) \(#fileID)")
   let newRecord = Record(context: context)
   newRecord.month = month
   newRecord.year = year

   do {
       try context.save()
      print("new Record saved succesfully.")

     } catch {
      print(error)
      }
      return newRecord
}

   class func newCustomer(name: String, age:Int, country: String, gender:String, record: Record?) {
   let context = getContext()

      print("Loading function: \(#function), line: \(#line) \(#fileID)")
      let newCustomer = Customer(context: context)
      newCustomer.name = name
      newCustomer.age = Int32(age)
      newCustomer.country = country
      newCustomer.gender = gender

      if record != nil {
      record!.addToCustomer(newCustomer)
      }
      do {
          try context.save()
         print("new Customer saved succesfully.")

        } catch {
         print(error)
         }
   }

   class func fetchRecordByMonthAndYear(month: String, year: String) -> [Record] {

      print("Loading function: \(#function), line: \(#line) \(#fileID)")
      let context = getContext()
      var record = [Record]()
      let recordFetchRequest: NSFetchRequest<Record> = Record.fetchRequest()

      let predicateMonth = NSPredicate(format: "month == %@", month)
      let predicateYear = NSPredicate(format: "year == %@", year)
      let predicateAnd = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateMonth, predicateYear])

      recordFetchRequest.predicate = predicateAnd
   do {
      record = try context.fetch(recordFetchRequest) }
   catch {
      print (error)
   }
return record


   }

   class func fetchCustomerByAge(age: Int) -> [Customer] {
      print("Loading function: \(#function), line: \(#line) \(#fileID)")
      let context = getContext()
      var customers = [Customer]()
      let customerFetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()

      let predicateage = NSPredicate(format: "age == %i", age)


      customerFetchRequest.predicate = predicateage
   do {
      customers = try context.fetch(customerFetchRequest) }
   catch {
      print (error)
   }
return customers


   }

   class func addCustomerToRecord(customer:Customer, record:Record) {
let context = getContext()

      record.addToCustomer(customer)
      do {
         try context.save()
      }
      catch {
         print (error)
      }

   }

   class func fetchCustomersByRecord(record:Record) -> [Customer] {
      print("Loading function: \(#function), line: \(#line) \(#fileID)")
      let context = getContext()
      var customers = [Customer]()
      let customerFetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()

      let predicateName = NSPredicate(format: "record == %@", record)


      customerFetchRequest.predicate = predicateName
   do {
      customers = try context.fetch(customerFetchRequest) }
   catch {
      print (error)
   }
return customers
   }

   class func fetchCustomerByName(name: String) -> [Customer] {
      print("Loading function: \(#function), line: \(#line) \(#fileID)")
      let context = getContext()
      var customers = [Customer]()
      let customerFetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()

      let predicateName = NSPredicate(format: "name == %@", name)


      customerFetchRequest.predicate = predicateName
   do {
      customers = try context.fetch(customerFetchRequest) }
   catch {
      print (error)
   }
return customers

   }

   class func updateCustomerAgeAndRecord(customer:Customer, newAge: Int, newRecord: Record) {
let context = getContext()

      customer.age = Int32(newAge)
      customer.record = newRecord
      do {
         try context.save()
      }
      catch {
         print (error)
      }


   }

   class func deleteAllCustomers(){
      let context = getContext()
      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Customer")
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

      do {
         try context.execute(deleteRequest)
      } catch { print(error)
      }
   }

   class func deleteAllRecords(){
      let context = getContext()
      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Record")
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

      do {
         try context.execute(deleteRequest)
      } catch { print(error)
      }
   }

}
