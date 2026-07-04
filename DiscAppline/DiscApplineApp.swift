//
//  DiscApplineApp.swift
//  DiscAppline
//
//  Created by Aram Gokce on 7/1/26.
//

import SwiftUI
import SwiftData

@main
struct DiscApplineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Routine.self)
    }
}
