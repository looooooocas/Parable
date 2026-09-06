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
    @State var viewmode: QuestLogMode = .activeQuests
    
    var activeQuests: [Quest] { // 
            return questLog.getActiveQuests(target: targetPlanet)
    }
    
    var completedQuests: [Quest]{
        return questLog.getCompletedQuests(target: targetPlanet)
    }
    
    var body: some View {
            VStack{
                HStack {
                    ProgressTrackerView(planet: targetPlanet, viewmode: $viewmode)
                    Text("Quest Log")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer() // Pushes the badge directly to the trailing right edge
                    AddQuestButton(formOnScreen: formOnScreen)
                    switch viewmode {
                    case .activeQuests:
                        Text("\(activeQuests.count)")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(10) // Controls how much room the badge has inside
                            .background(Circle().fill(Color.blue)) // Pure, tiny background circle asset
                    case .completedQuests:
                        Text("\(completedQuests.count)")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(10) // Controls how much room the badge has inside
                            .background(Circle().fill(Color.blue)) // Pure, tiny background circle asset
                    }
                }
                ScrollView {
                    LazyVStack(spacing: 0) {
                        switch viewmode {
                            case .activeQuests:
                            ForEach(activeQuests) { quest in
                                QuestView(quest)
                            }
                            case .completedQuests:
                            ForEach(completedQuests) { quest in
                                QuestView(quest)
                            }
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

enum QuestLogMode {
    case activeQuests
    case completedQuests
    
    mutating func toggle() {
        switch self {
        case .activeQuests:
            self = .completedQuests
        case .completedQuests:
            self = .activeQuests
        }
    }
}

#Preview {
    QuestLogView(formOnScreen: .constant(false))
}
