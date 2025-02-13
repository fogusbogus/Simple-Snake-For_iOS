//
//  Snake2App.swift
//  Snake2
//
//  Created by Matt Hogg on 25/01/2025.
//

import SwiftUI
import SwiftData

@main
struct Snake2App: App {
	
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            //ContentView()
			GameplayArea()
				
        }
        .modelContainer(sharedModelContainer)
    }
}
