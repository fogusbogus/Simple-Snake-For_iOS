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
				.onAppear {
					let box: [CGPoint] = [
						CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 2, y: 0),
						CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 1),
						CGPoint(x: 0, y: 2), CGPoint(x: 1, y: 2), CGPoint(x: 2, y: 2),
					]
					FindPath.canGetTo(a: CGPoint(x: 1, y: 1), b: CGPoint(x: 5, y: 5), objects: box, size: CGSize(width: 20, height: 20))
				}
        }
        .modelContainer(sharedModelContainer)
    }
}
