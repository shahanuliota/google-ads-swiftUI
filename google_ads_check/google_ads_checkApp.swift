//
//  google_ads_checkApp.swift
//  google_ads_check
//
//  Created by Shahanul on 16/7/23.
//

import SwiftUI

@main
struct google_ads_checkApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
