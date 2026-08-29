//
//  Engine.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-22.
//

import Foundation
import SwiftData


@MainActor
final class Engine {
    static let shared = Engine()
    
    let container: ModelContainer
    @MainActor let context: ModelContext
    
    // Hold your independent, modular manager systems here
    @MainActor let quests: QuestLog
    @MainActor let planets: PlanetManager
    
    private init() {
        do {
            // A. Configure schemas and persistent disk configs
            let schema = Schema([Planet.self, Quest.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            // B. Spin up the physical database files
            let sharedContainer = try ModelContainer(for: schema, configurations: [config])
            self.container = sharedContainer
            self.context = sharedContainer.mainContext
            
            DatabaseSeeder.seedInitialDataIfNeeded(context: self.context)
            
            // C. Instantiate subsystems by feeding them the stable disk context
            self.quests = QuestLog(modelContext: context)
            self.planets = PlanetManager(modelContext: context)
            
        } catch {
            fatalError("CRITICAL: Failed to initialize global data engine: \(error)")
        }
    }
}
