//
//  ProgressTrackerView.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-08-29.
//

import SwiftUI

struct ProgressTrackerView: View { // rename?
    let planet: Planet?
    @Binding var viewmode: QuestLogMode
    
    init(planet: Planet? = nil, viewmode: Binding<QuestLogMode>) {
        self.planet = planet
        _viewmode = viewmode
    }
    
    var weeklyProgress: Int {
        let calendar = Calendar.current
        let today = Date()
        
        // Monday as first weekday
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        return questLog.getAllQuests(target: planet).filter { quest in
            guard let date = quest.date else { return false }
            return date >= startOfWeek && quest.isCompleted
        }.count
    }
    
    var outstandingQuests: Int {
        return questLog.getAllQuests(target: planet).filter { quest in
            return !quest.isCompleted
        }.count
    }
    
    var body: some View {
        Button {
            viewmode.toggle()
        } label: {
            switch viewmode {
                case .activeQuests:
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                    Text("\(weeklyProgress)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 2)
                )
                
                case .completedQuests:
                HStack(spacing: 4) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 20))
                    Text("\(outstandingQuests)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 2)
                )
            }
        }
    }
}

