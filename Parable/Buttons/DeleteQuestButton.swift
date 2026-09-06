//
//  DeleteQuestButton.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-07-29.
//

import SwiftUI

struct DeleteQuestButton: View {
    var quest: Quest
    var body: some View {
        Button(action: {questLog.deleteQuest(quest)})
        {
            Image(systemName: "minus.circle.fill")
                .resizable() // 💡 Allows the system icon asset to scale manually
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
        }
        .padding()
    }
}


