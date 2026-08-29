//
//  ParableApp.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-01.
//

import SwiftUI
import SwiftData

@main
struct ParableApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(Engine.shared.container)
    }
}
