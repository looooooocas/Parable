//
//  CompleteQuestButton.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-08-25.
//

import SwiftUI

struct CompleteQuestButton: View {
    var quest: Quest
    var body: some View {
        Button(action: {questLog.completeQuest(quest)})
        {
            Image(systemName: "checkmark.circle.fill")
                .resizable() // 💡 Allows the system icon asset to scale manually
                .frame(width: 30, height: 30)
                .foregroundColor(.green)
        }
        .padding()
    }
}

