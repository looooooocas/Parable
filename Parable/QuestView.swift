//
//  QuestView.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-02.
//

import SwiftUI

struct QuestView : View {
    
    let quest: Quest
    @State var offset: CGFloat = 0
    
    init(_ quest: Quest) {
        self.quest = quest
    }

    var body: some View {
        ZStack {
            HStack{
                DeleteQuestButton(quest: quest)
                Spacer()
            }
            HStack{
                Text(quest.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical,2)
                // 1. Force the bar to a precise structural layout length
                    .frame(width: 150, height: 36, alignment: .leading)
                // 2. Style the background container bounding box
                    .foregroundColor(.black) 
                    .background(Color(.white))
                    .cornerRadius(8)
                // 3. Prevent the text from wrapping onto a second line or breaking the frame
                    .lineLimit(1)
                // 4. Clean up overflow with an ellipsis (...) if it cuts off
                    .truncationMode(.tail)
                Spacer()
                Text(quest.owner.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: 120, alignment: .center)
                Spacer()
                switch quest.isCompleted {
                    case false: // Active Quest
                    if quest.dateDue != nil {
                        Text(quest.formattedDate(questDate: quest.dateDue!))
                            .foregroundColor(quest.isOverdue ? .red : .secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: 130, alignment: .center)
                    } else {
                        Text("-")
                    }
                    CompleteQuestButton(quest: quest)
                    case true: // Completed Quest
                    if quest.dateCompleted != nil {
                        Text(quest.formattedDate(questDate: quest.dateCompleted!))
                            .foregroundColor(quest.isOverdue ? .red : .secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: 130, alignment: .center)
                    } else {
                        Text("-")
                    }
                    UncompleteQuestButton(quest: quest)
                }
            }
                .offset(x: offset)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 15)
                        .onChanged { value in
                            let horizontal = abs(value.translation.width)
                            let vertical = abs(value.translation.height)
                            guard horizontal > vertical else { return }
                            withAnimation(.interactiveSpring()){
                                offset = max(value.translation.width, 0)
                            }
                        }
                        .onEnded { value in
                            let horizontal = abs(value.translation.width)
                            let vertical = abs(value.translation.height)
                            guard horizontal > vertical else { return }
                            withAnimation {
                                offset = value.translation.width > 40 ? 80 : 0
                            }
                        }
                )
        }
    }
}

