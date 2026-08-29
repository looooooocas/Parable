//
//  ContentView.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-01.
//

import SwiftUI

var planets: PlanetManager { Engine.shared.planets }
var questLog: QuestLog { Engine.shared.quests }

struct HomeView: View {
    
    @State private var taskFormOn = false
    @State private var planetFormOn = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    QuestLogView(formOnScreen: $taskFormOn)
                        .padding(.bottom, 10)
                    Spacer()
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                HStack{ // colonies
                    ForEach(planets.colonies) { planet in
                        NavigationLink(destination: PlanetPage(planet: planet)){
                            PlanetView(planet: planet, size: 150)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    AddPlanetButton(showingForm: $planetFormOn)
                }
                Spacer()
                NavigationLink(destination: PlanetPage(planet: planets.capitol)){
                    PlanetView(planet: planets.capitol, size: 300)
                }
            }
            .background(
                Image("Starscape")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .sheet(isPresented: $taskFormOn) {
            QuestCreationForm()
        }
    }
}

#Preview {
    HomeView()
}
