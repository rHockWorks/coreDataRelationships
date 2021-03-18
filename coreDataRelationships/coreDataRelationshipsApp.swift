//
//  coreDataRelationshipsApp.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//

import SwiftUI

@main
struct coreDataRelationshipsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
