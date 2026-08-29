//
//  AddPlanetButton.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-03.
//

import SwiftUI
import SwiftData

struct AddPlanetButton: View {
    
    @Binding var showingForm: Bool
    
    var body: some View {
        Button {
            showingForm = true
        } label: {
            Label("", systemImage: "plus.circle.fill")
        }
        .sheet(isPresented: $showingForm) {
            PlanetCreationForm()
        }
    }
}

struct PlanetCreationForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    @State private var planet_name: String = ""
    @State private var planet_icon: PlanetIcon = .earth
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Planet Name")) {
                    TextField("Enter Planet Name", text: $planet_name)
                }
                Section(header: Text("Icon")) {
                    // THIS is the clean approach - just a Menu
                    HStack {
                        Menu {
                            ForEach(PlanetIcon.allCases, id: \.self) { icon in
                                Button {
                                    planet_icon = icon
                                } label: {
                                    HStack {
                                        Image(icon.rawValue)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                        Text(icon.displayName)
                                        if planet_icon == icon {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(planet_icon.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text(planet_icon.displayName)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                Section{
                    Button("Add Planet"){
                        //ensure form is sufficient: Has name etc.
                        let newPlanet = Planet(name: planet_name, icon: planet_icon)
                        planets.addPlanet(newPlanet)
                        modelContext.insert(newPlanet)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        PlanetCreationForm()
    }
    .padding()
}
