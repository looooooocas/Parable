//
//  AddTask.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-03.
//

import SwiftUI
import SwiftData

struct AddQuestButton: View {
    @Binding var formOnScreen: Bool
    var body: some View {
        Button(action: {
            formOnScreen.toggle()
        })
        {
            Image(systemName: "plus.circle.fill")
                .resizable() // 💡 Allows the system icon asset to scale manually
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct QuestCreationForm: View {
    
    let planetsList = [planets.capitol] + planets.colonies
    @State var owner: Planet = planets.capitol
    @State var questName: String = ""
    @State var description: String = ""
    @State var hasDate: Bool = true
    @State var questDate: Date = { // defaults to 11:59 pm
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!
        return Calendar.current.date(byAdding: .second, value: -1, to: startOfTomorrow) ?? Date()
    }()
    @State var questReocc: Recurrence = .None
    @State var workloadEstimate: Int?
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Name")){
                    TextField("Enter task name...", text: $questName)
                        .autocorrectionDisabled(true)
                }
                Section(header: Text("Planet")){
                    Picker("Planet...", selection: $owner){
                        ForEach(planetsList, id: \.self) { planet in
                            Text(planet.name)
                        }
                    }
                }
                Section(header: Text("Description")){
                    TextField("Enter a description...", text: $description)
                }
                Section(header: Text("Date")){
                    Toggle("Date", isOn: $hasDate)
                    DatePicker("Date", selection: $questDate)
                }
                Section(header: Text("Reoccurence")){
                    Picker("Repeats...", selection: $questReocc){
                        ForEach (Recurrence.allCases, id: \.self){ reocc in
                            Text(reocc.rawValue)
                        }
                    }
                }
                Section(header: Text("Work Load Estimate")){ // TODO: selection?
                    TextField("Workload Estimate", value: $workloadEstimate, format: .number)
                        .keyboardType(.numberPad)
                }
                Section{
                    Button("Create Task"){
                        //ensure form is sufficient
                        let newQuest = Quest(name: questName, description: description, date: hasDate ? questDate : nil, isCompleted: false, owner: owner, reoccurence: questReocc, workLoadEst: workloadEstimate)
                        questLog.addQuest(newQuest)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var formOnScreen = false
    AddQuestButton(formOnScreen: $formOnScreen)
}
