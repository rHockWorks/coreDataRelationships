//
//  DataManager.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//  Updated by Rudolph Hock on 21st March, 2021

import Foundation
import CoreData

class DataManager {
    
    enum CoreDataError: String, Error {
        
        case
        fetchRequest    = "Unable to fetch or create list",
        fetchObject     = "Unable to fetch managed objects for entity",
        saveObject      = "Unable to save managed object context",
        deleteRequest   = "Unable to delete object"
    }
    
    enum CoreDataConfirmation: String {
        
        case
        dataSaved       = "New Record saved succesfully"
    }

    enum PredictaeCheck: String {
        
        case
        name            = "name == %@",
        month           = "month == %@",
        year            = "year == %@"
    }
    
    
    private class func getContext() -> NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }

    
    
    
    
    class func addRecord(withCustomerName customerName      : String,
                         CustomerAge customerAge            : Int32,
                         CustomerCountry customerCountry    : String,
                         CustomerGender customerGender      : String,
                         forRecord record                   : (String, String)) {
        
        let checkMonth          : String    = record.0
        let checkYear           : String    = record.1
        let context                         = getContext()
        let customerData                    = Customer(context: context)
        let checkStageSeason    : Bool      = DataManager.checkEntryExists(forMonth: checkMonth, forYear: checkYear)
        
   
        customerData.name       = customerName
        customerData.age        = customerAge
        customerData.country    = customerCountry
        customerData.gender     = customerGender

        
        if checkStageSeason == false {

            createRecord(withCustomer: customerName, forRecord: record)
        
        } else if checkStageSeason == true {

            updateRecord(withCustomer: customerData, forRecord: record)
        }
    }
    
    
    class func createRecord(withCustomer customer: String, forRecord record: (String, String)) {
        
        let checkMonth      : String    = record.0
        let checkYear       : String    = record.1
        
        DataManager.saveNewRecord(month: checkMonth, year: checkYear)
        
        let newCustomer = DataManager.fetchCustomerData(forName: customer, with: .name)[0]
        let forRecord   = DataManager.fetchRecordByMonthAndYear(month: checkMonth, year: checkYear)[0]
        
        DataManager.addCustomerToRecord(customer: newCustomer, record: forRecord)
    }
    
    
    class func updateRecord(withCustomer customer: Customer, forRecord record: (String, String)) {
        
        let checkMonth  : String    = record.0
        let checkYear   : String    = record.1
        let newCustomer = DataManager.fetchCustomerData(forName: customer.name ?? "TEMP", with: .name)[0]
        let forRecord   = DataManager.fetchRecordByMonthAndYear(month: checkMonth, year: checkYear)[0]
        
        DataManager.addCustomerToRecord(customer: newCustomer, record: forRecord)
    }
     
    
    class func purgeRecord(forCustomer customer: String, inRecord record: (String, String)) {
        
        let checkMonth          : String    = record.0
        let checkYear           : String    = record.1
        let checkStageSeason    : Bool      = DataManager.checkEntryExists(forMonth: checkMonth, forYear: checkYear)
        
        if checkStageSeason == true {

            let customerOfInterest  = DataManager.fetchCustomerData(forName: customer, with: .name)[0]
            let forRecord           = DataManager.fetchRecordByMonthAndYear(month: checkMonth, year: checkYear)[0]
            
            DataManager.removeCustomerFromRecord(customer: customerOfInterest, record: forRecord)
        }
    }
       
        
    private class func fetchCustomerData(forName name: String, with: PredictaeCheck) -> [Customer] {
     
        let context             = getContext()
        var customers           = [Customer]()
        let customerFetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
        var predicateName       : NSPredicate {
                                               switch with {
                                               case .name  : return NSPredicate(format: PredictaeCheck.name.rawValue, name)
                                               default     : return NSPredicate(format: PredictaeCheck.name.rawValue, name)
                                               }
                                           }
       
        customerFetchRequest.predicate = predicateName
       
        do {
            customers = try context.fetch(customerFetchRequest)
           
        } catch {
            print (error)
        }
        return customers
    }
    
    
    private class func fetchRecordByMonthAndYear(month: String, year: String) -> [Record] {

        let context             = getContext()
        var record              = [Record]()
        let recordFetchRequest  : NSFetchRequest<Record> = Record.fetchRequest()
        let predicateMonth      = NSPredicate(format: PredictaeCheck.month.rawValue, month)
        let predicateYear       = NSPredicate(format: PredictaeCheck.year.rawValue, year)
        let predicateAnd        = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateMonth, predicateYear])

        recordFetchRequest.predicate = predicateAnd
        
        do {
            record = try context.fetch(recordFetchRequest)
        
        } catch {
            print (CoreDataError.fetchObject.rawValue, error)
        }
        return record
    }
    

    private class func checkEntryExists(forMonth month: String, forYear year: String) -> Bool {

        let context             = getContext()
        var returnCondition     : Bool = false
        let recordFetchRequest  : NSFetchRequest<Record> = Record.fetchRequest()
        let predicateMonth      = NSPredicate(format: PredictaeCheck.month.rawValue, month)
        let predicateYear       = NSPredicate(format: PredictaeCheck.year.rawValue, year)
        let predicateComplete   = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateMonth, predicateYear])

        recordFetchRequest.predicate = predicateComplete
       
        do {
            if try context.fetch(recordFetchRequest).isEmpty == false { returnCondition = true }
        
        } catch {
            print (CoreDataError.fetchObject.rawValue, error)
        }
        return returnCondition
    }
    
    
    class func fetchAllRecords() -> [Record] {
          
        let context             = getContext()
        var records             = [Record]()
        let recordsFetchRequest : NSFetchRequest<Record> = Record.fetchRequest()
          
        
        do {
            records = try context.fetch(recordsFetchRequest)
            
        } catch {
            print (CoreDataError.fetchRequest.rawValue, error)
        }
        return records
    }
        
        
    private class func addCustomerToRecord(customer: Customer, record: Record) {
        
        let context = getContext()

        record.addToCustomer(customer)
        
        saveData(with: context)
    }
        
        
    private class func removeCustomerFromRecord(customer: Customer, record: Record) {
         
        let context = getContext()

        record.removeFromCustomer(customer)
           
        saveData(with: context)
    }

    
    private class func saveNewRecord(month: String, year: String) {
        
        let context     = getContext()
        let newRecord   = Record(context: context)
        
        newRecord.month = month
        newRecord.year  = year

        saveData(with: context)
    }
    

    private class func saveData(with: NSManagedObjectContext) {
        
        let context = getContext()
        
        do {
            try context.save()
            print(CoreDataConfirmation.dataSaved.rawValue)

         } catch {
            print(CoreDataError.saveObject.rawValue, error)
        }
    }

    
    
    
    
    
    
    
    
    
    //FIXME: NOTE YET IN USE : REFACTOR METHOD FOR CONTEXT FETCH REQUEST
    class func fetchData(withRequest request: NSFetchRequest<NSManagedObject>) -> [NSManagedObject] {
        
        let context = getContext()
        var returnData = [NSManagedObject]()
        
        do {
            returnData = try context.fetch(request)
            
        } catch {
            print (CoreDataError.fetchRequest.rawValue, error)
        }
        return returnData
    }
        
        
    //NOT IN USE
    class func deleteAllCustomers() {
        
        let context         = getContext()
        let fetchRequest    : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Customer")
        let deleteRequest   = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        
        } catch {
            print(CoreDataError.deleteRequest.rawValue, error)
        }
    }

        
    //NOT IN USE
    class func deleteAllRecords() {
        
        let context         = getContext()
        let fetchRequest    : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Record")
        let deleteRequest   = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        
        } catch {
            print(CoreDataError.deleteRequest.rawValue, error)
        }
    }
        
        
    
    
    
    
    
    
    
    //TEMP
    func printRecords111(time: Int) {
    
    let allRecords = DataManager.fetchAllRecords()
    
        print("///////////////////////// [\(time)] //////////////////////////////////")
        for record in allRecords {
            print("VBSSU01 : \(record.month)")
            print("VBSSU02 : \(record.year)")
            for customer in record.customerArray {
                print("VBSSU03 : \(customer.name)")
                print("VBSSU04 : \(customer.age)")
                print("VBSSU05 : \(customer.gender)")
                print("VBSSU06 : \(customer.country)")
            }
        }
        print("///////////////////////////////////////////////////////////")
    }
    
    
    
    
}
