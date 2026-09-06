//
//  PlanetMangaer.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-03.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class PlanetManager {
    private var modelContext: ModelContext
    
    public var colonies: [Planet]
    public var capitol: Planet
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        
        let isCapitol = FetchDescriptor<Planet>(predicate: #Predicate {$0.isCapitol })
        
        do { // Load Capital
            self.capitol = try modelContext.fetch(isCapitol).first ?? Planet(name: "Capitol", isCapitol: true, icon: .earth) // redundant with Seeder
        } catch {
            print("⚠️ Failed to load Capital from disk: \(error)")
            
            self.capitol = Planet(name: "Capitol", isCapitol: true, icon: .earth) // This probably shouldn't happen on a failed load but removing it caused a bug I'm too lazy to deal with
        }
        let isColony = FetchDescriptor<Planet>(predicate: #Predicate {!$0.isCapitol })
        
        do { // Load Colonies
            self.colonies = try modelContext.fetch(isColony)
        } catch {
            print("⚠️ Failed to load colonies from disk: \(error)")
            self.colonies = []
        }
    }
    
    public func addPlanet(_ planet: Planet) {
        self.modelContext.insert(planet)
        try? modelContext.save()
        modelContext.processPendingChanges()
        colonies.append(planet)
    }
    
    public func deletePlanet(_ planet: Planet) {
        if (!planet.isCapitol){
            self.modelContext.delete(planet)
            try? modelContext.save()
            modelContext.processPendingChanges()
            colonies.removeAll(where: { $0.id == planet.id })
        } //TODO: else warning 
    }
    
    public func editPlanet(_ planet: Planet, name: String, icon: String) {
        planet.name = name
        planet.icon = icon
        try? modelContext.save()
        modelContext.processPendingChanges()
    }
}
