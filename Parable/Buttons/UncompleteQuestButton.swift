//
//  CompleteQuestButton.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-08-25.
//

import SwiftUI

struct UncompleteQuestButton: View {
    var quest: Quest
    var body: some View {
        Button(action: {questLog.uncompleteQuest(quest)})
        {
            Image(systemName: "arrow.uturn.backward.circle.fill")
                .resizable() // 💡 Allows the system icon asset to scale manually
                .frame(width: 30, height: 30)
                .foregroundColor(.orange)
        }
        .padding()
    }
}

