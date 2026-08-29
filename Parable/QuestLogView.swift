//
//  QuestLogView.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-02.
//


import SwiftUI

struct QuestLogView: View {
    var targetPlanet: Planet? = nil
    let formOnScreen: Binding<Bool>
    @State private var questLog: QuestLog = Engine.shared.quests
    
    var activeQuests: [Quest] {
        if let planet = targetPlanet {
            return questLog.getActiveQuests(target: planet)
        } else {
            return questLog.getActiveQuests()
        }
    }
    
    var body: some View {
            VStack{
                HStack {
                    Text("Quest Log")
                    Spacer() // Pushes the badge directly to the trailing right edge
                    AddQuestButton(formOnScreen: formOnScreen)
                    Text("\(activeQuests.count)")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(10) // Controls how much room the badge has inside
                        .background(Circle().fill(Color.blue)) // Pure, tiny background circle asset
                        }
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(activeQuests) { quest in
                            QuestView(quest)
                        }
                    }
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .opacity(0.75)
                    .foregroundColor(.gray)
                )
                .padding(10)
    }
}
#Preview {
    QuestLogView(formOnScreen: .constant(false))
}
