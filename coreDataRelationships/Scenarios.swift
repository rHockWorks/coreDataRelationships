//
//  Scenarios.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//

import Foundation

struct Scenarios{

   static func scenario1(){
      let record = DataManager.fetchRecordByMonthAndYear(month: "April", year: "2021")
      if record.count == 1 {
         DataManager.newCustomer(name: "Ed Sheeran", age: 30, country: "England", gender: "Male", record: record[0])
         DataManager.newCustomer(name: "Tom Hanks", age: 64, country: "USA", gender: "Male", record: record[0])
         DataManager.newCustomer(name: "Margot Robbie", age: 30, country: "Australia", gender: "Female", record: record[0])

      }
   }

   static func scenario2(){
      let record = DataManager.newRecord(month: "May", year: "2021")
      let customersAged58 = DataManager.fetchCustomerByAge(age: 58)
      for customer in customersAged58 {
         DataManager.addCustomerToRecord(customer:customer, record:record)
      }
   }

  static func scenario3(){
      let returnedCustomers = DataManager.fetchCustomerByName(name: "Cust 5")
      let record = DataManager.fetchRecordByMonthAndYear(month: "March", year: "2021")
      if returnedCustomers.count == 1 && record.count == 1 {
         if record.count == 1 {
            DataManager.updateCustomerAgeAndRecord(customer:returnedCustomers[0], newAge: 70, newRecord: record[0])
         }
      }
   }



}
