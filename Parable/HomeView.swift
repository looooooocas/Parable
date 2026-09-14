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
                        .frame(maxHeight: 300)  
                    Spacer()
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                // Colonies strip with horizontal scrolling
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(planets.colonies) { planet in
                            NavigationLink(destination: PlanetPage(planet: planet)){
                                PlanetView(planet: planet, size: 150)
                            }
                        }
                        AddPlanetButton(showingForm: $planetFormOn)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
