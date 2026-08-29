//
//  PlanetPage.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-01.
//

import SwiftUI

struct PlanetPage: View {
    let planet: Planet
    @State var AddTaskForm: Bool = false
    @State var EditPlanetFormShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text(planet.name).bold(true).foregroundColor(Color.white)
                    Spacer()
                    EditPlanetButton(planet: planet, formOnScreen: $EditPlanetFormShowing)
                        .padding(10)
                }
                QuestLogView(targetPlanet: planet, formOnScreen: $AddTaskForm)
                Spacer()
                PlanetView(planet: planet, size: 300)
            }
            .background(
                Image("Starscape")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .sheet(isPresented: $AddTaskForm) {
            QuestCreationForm(owner: planet)
        }
        .sheet(isPresented: $EditPlanetFormShowing) {
            EditPlanetForm(planet: planet)
        }
    }
}

// Preview ?
