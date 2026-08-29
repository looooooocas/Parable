//
//  DBSeeder.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-08-17.
//

import Foundation
import SwiftData


@MainActor
class DatabaseSeeder {
    static func seedInitialDataIfNeeded(context: ModelContext) {
        let hasSeeded = UserDefaults.standard.bool(forKey: "hasSeededInitialData")
        guard !hasSeeded else { return }
        
        // Create and persist the Capitol
        let capitol = Planet(name: "Capitol", isCapitol: true, icon: .earth)
        context.insert(capitol)
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "hasSeededInitialData")
        } catch {
            print("Failed to seed database: \(error)")
        }
    }
}
