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
                    .padding(.vertical,4)
                // 1. Force the bar to a precise structural layout length
                    .frame(width: 150, height: 36, alignment: .leading)
                // 2. Style the background container bounding box
                    .background(Color(.white))
                    .cornerRadius(8)
                // 3. Prevent the text from wrapping onto a second line or breaking the frame
                    .lineLimit(1)
                // 4. Clean up overflow with an ellipsis (...) if it cuts off
                    .truncationMode(.tail)
                Spacer()
                Text(quest.owner.name)
                Spacer()
                if quest.date != nil {
                    Text(quest.formattedDate)
                        .foregroundColor(quest.isOverdue ? .red : .secondary)
                }
                CompleteQuestButton(quest: quest)
            }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.interactiveSpring()){
                                offset = max(value.translation.width, 0)
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                offset = value.translation.width > 40 ? 80 : 0
                            }
                        }
                )
        }
    }
}
