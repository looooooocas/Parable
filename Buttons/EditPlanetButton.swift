//
//  EditPlanetButton.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-07-29.
//

import SwiftUI

struct EditPlanetButton: View {
    let planet: Planet
    @Binding var formOnScreen: Bool
    var body: some View {
        Button(action: {formOnScreen.toggle()})
        {
            Image(systemName: "pencil.circle.fill")
                .resizable() // 💡 Allows the system icon asset to scale manually
                .frame(width: 30, height: 30)
                .foregroundColor(.orange)
        }
    }
}

struct EditPlanetForm: View {
    let planet: Planet
    
    @State var name: String = ""
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Name")){
                    TextField("Enter planet name...", text: $name)
                        .autocorrectionDisabled(true)
                }
                //TODO: Actually let you edit lol
                Section(header: Text("Delete")){
                    Button(action: {
                        planets.deletePlanet(planet)
                        dismiss()
                    })
                    {
                        Image(systemName: "minus.circle.fill")
                            .resizable() // 💡 Allows the system icon asset to scale manually
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                }
                
            }
            .onAppear {
                name = planet.name
            }
        }
    }
}
