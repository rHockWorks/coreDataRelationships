//
//  ContentView.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
   @Environment(\.managedObjectContext) private var viewContext
   @State var allRecords: [Record] = []
   var body: some View {
      VStack (spacing: 10) {

         VStack{
            Button(action: {
               Scenarios.scenario1()
               allRecords = []
               allRecords = DataManager.fetchAllRecords()
            }) {
               Text("Scenario 1")
            }.buttonStyle(BigBoldSlimline())

            Text("Creates 3 new customers and then adds them to the April 2021 record").font(.caption).foregroundColor(Color.gray)
            Divider()
         }
         VStack {
            Button(action: {
               Scenarios.scenario2()
               allRecords = []
               allRecords = DataManager.fetchAllRecords()
            }) {
               Text("Scenario 2")
            }.buttonStyle(BigBoldSlimline())
            Text("Creates new May 2021 Record and adds 4 existing customers to it").font(.caption).foregroundColor(Color.gray)
            Divider()
         }
         VStack {
            Button(action: {
               Scenarios.scenario3()
               allRecords = []
               allRecords = DataManager.fetchAllRecords()
            })
            {
               Text("Scenario 3")
            }.buttonStyle(BigBoldSlimline())
            Text("Fetches Customer 5 and changes his age to 70 then moves him to March 2021 record").font(.caption).foregroundColor(Color.gray)
            Divider()
         }

         VStack{
            Button(action: {
               DataManager.deleteAllCustomers()
               DataManager.deleteAllRecords()
               DataManager.newRecord(month: "February", year: "2021")
               DataManager.newRecord(month: "March", year: "2021")
               DataManager.newRecord(month: "April", year: "2021")
               DataManager.newCustomer(name: "Cust 1", age: 58, country: "USA", gender: "Male", record: nil)
               DataManager.newCustomer(name: "Cust 2", age: 58, country: "Mexico", gender: "Female", record: nil)
               DataManager.newCustomer(name: "Cust 3", age: 58, country: "Germany", gender: "Male", record: nil)
               DataManager.newCustomer(name: "Cust 4", age: 58, country: "Spain", gender: "Female", record: nil)
               DataManager.newCustomer(name: "Cust 5", age: 65, country: "Switzerland", gender: "Male", record: nil)
               let cust5 = DataManager.fetchCustomerByName(name: "Cust 5")[0]
               let Feb21 = DataManager.fetchRecordByMonthAndYear(month: "February", year: "2021")[0]
               DataManager.addCustomerToRecord(customer: cust5, record: Feb21)
               allRecords = []
               allRecords = DataManager.fetchAllRecords()
            })
            {
               Text("Reset")
            }.buttonStyle(BigBoldSlimline())
            Text("Resets back to starting point - 4 customers, not linked to any record. 2 empty momnths, 1 month with cust 5 in").font(.caption).foregroundColor(Color.gray)
            Divider()
         }


         Text("List Of Records").bold()


         List() {
            ForEach(allRecords) { record in
               Section(header: Text("\(record.month ?? "") \(record.year ?? "")"), content: {
                  if record.customerArray.count == 0 {
                     Text("No Customers")
                  }
                  ForEach(record.customerArray) { customer in
                     HStack{
                        Text("Name: \(customer.name ?? "")")
                        Text("Age: \(customer.age)")
                        Text("Country: \(customer.country ?? "")")
                      
                     }.font(.caption)
                  }
                  }
            )
            }
         }


      }
      .padding()
      .onAppear{
         DataManager.deleteAllCustomers()
         DataManager.deleteAllRecords()
         DataManager.newRecord(month: "February", year: "2021")
         DataManager.newRecord(month: "March", year: "2021")
         DataManager.newRecord(month: "April", year: "2021")
         DataManager.newCustomer(name: "Cust 1", age: 58, country: "USA", gender: "Male", record: nil)
         DataManager.newCustomer(name: "Cust 2", age: 58, country: "Mexico", gender: "Female", record: nil)
         DataManager.newCustomer(name: "Cust 3", age: 58, country: "Germany", gender: "Male", record: nil)
         DataManager.newCustomer(name: "Cust 4", age: 58, country: "Spain", gender: "Female", record: nil)
         DataManager.newCustomer(name: "Cust 5", age: 65, country: "Switzerland", gender: "Male", record: nil)
         let cust5 = DataManager.fetchCustomerByName(name: "Cust 5")[0]
         let Feb21 = DataManager.fetchRecordByMonthAndYear(month: "February", year: "2021")[0]
         DataManager.addCustomerToRecord(customer: cust5, record: Feb21)
         allRecords = []
         allRecords = DataManager.fetchAllRecords()

         let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
         let dbName = PersistenceController.shared.container.name
         let pasteboard = UIPasteboard.general
         pasteboard.string = (path[0] + "/\(dbName).sqlite")
        print (path[0] + "/\(dbName).sqlite")

      }

   }



}


