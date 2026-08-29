//
//  Planet.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-01.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Planet {
    var name: String
    var isCapitol: Bool = false
    var icon: String
    var completedQuests: [Quest] = []
    
    init(name: String, isCapitol: Bool = false, icon: PlanetIcon) {
            self.name = name
            self.isCapitol = isCapitol
            self.icon = icon.displayName
        }
}



enum PlanetIcon: String, CaseIterable, Codable {
    case earth = "Earth"
    case pluto = "Pluto"
    case eos = "Eos"
    
    var displayName: String {
        switch self {
        case .earth: return "Earth"
        case .pluto: return "Pluto"
        case .eos: return "Eos"
        }
    }
}

struct PlanetView: View {
    let planet: Planet
    var size: CGFloat = 60
    
    var body: some View {
        Image(planet.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)  // Maintains aspect ratio
            .frame(width: size, height: size)
            .clipped()  // Prevents overflow
    }
}


