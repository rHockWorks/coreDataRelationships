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
      VStack (spacing: 30) {

         VStack{
            Button(action: {
               scenario1()
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
              scenario2()
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
             scenario3()
               allRecords = []
               allRecords = DataManager.fetchAllRecords()
            })
            {
               Text("Scenario 3")
            }.buttonStyle(BigBoldSlimline())
            Text("Fetches Tom Hanks and changes his age to 70 then moves him to March 2021 record").font(.caption).foregroundColor(Color.gray)
            Divider()
         }

         VStack{
            Button(action: {
               DataManager.deleteAllCustomers()
               DataManager.deleteAllRecords()
               DataManager.newRecord(month: "March", year: "2021")
               DataManager.newRecord(month: "April", year: "2021")
               DataManager.newCustomer(name: "Customer 1", age: 58, country: "USA", gender: "Male", record: nil)
               DataManager.newCustomer(name: "Customer 2", age: 58, country: "Mexico", gender: "Female", record: nil)
               DataManager.newCustomer(name: "Customer 3", age: 58, country: "Germany", gender: "Male", record: nil)
               DataManager.newCustomer(name: "Customer 4", age: 58, country: "Spain", gender: "Female", record: nil)
               allRecords = []
               allRecords = DataManager.fetchAllRecords()
            })
            {
               Text("Reset")
            }.buttonStyle(BigBoldSlimline())
            Text("Resets back to starting point - 4 customers, not linked to any record and 2 empty momnths").font(.caption).foregroundColor(Color.gray)
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
                        Text("\(customer.name ?? "")")
                        Text("\(customer.age)")
                        Text("\(customer.country ?? "")")
                     }
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
         DataManager.newRecord(month: "March", year: "2021")
         DataManager.newRecord(month: "April", year: "2021")
         DataManager.newCustomer(name: "Customer 1", age: 58, country: "USA", gender: "Male", record: nil)
         DataManager.newCustomer(name: "Customer 2", age: 58, country: "Mexico", gender: "Female", record: nil)
         DataManager.newCustomer(name: "Customer 3", age: 58, country: "Germany", gender: "Male", record: nil)
         DataManager.newCustomer(name: "Customer 4", age: 58, country: "Spain", gender: "Female", record: nil)
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

func scenario1(){
   let record = DataManager.fetchRecordByMonthAndYear(month: "April", year: "2021")
   if record.count == 1 {
      DataManager.newCustomer(name: "Ed Sheeran", age: 30, country: "England", gender: "Male", record: record[0])
      DataManager.newCustomer(name: "Tom Hanks", age: 64, country: "USA", gender: "Male", record: record[0])
      DataManager.newCustomer(name: "Margot Robbie", age: 30, country: "Australia", gender: "Female", record: record[0])

   }
}

func scenario2(){
   let record = DataManager.newRecord(month: "May", year: "2021")
   let customersAged58 = DataManager.fetchCustomerByAge(age: 58)
   for customer in customersAged58 {
      DataManager.addCustomerToRecord(customer:customer, record:record)
   }
}

func scenario3(){
   let returnedCustomers = DataManager.fetchCustomerByName(name: "Tom Hanks")
   let record = DataManager.fetchRecordByMonthAndYear(month: "March", year: "2021")
   if returnedCustomers.count == 1 && record.count == 1 {
      if record.count == 1 {
         DataManager.updateCustomerNameAndRecord(customer:returnedCustomers[0], newAge: 70, newRecord: record[0])
      }
   }
}
