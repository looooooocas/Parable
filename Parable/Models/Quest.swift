//
//  PlanetTask.swift
//  Parable
//
//  Created by Lucas Cosmo on 2026-06-01.
//

import Foundation
import SwiftUI
import SwiftData


@Model
class Quest : Hashable{
    var name: String
    var descr: String?
    var date: Date?
    var isCompleted: Bool = false
    var owner: Planet
    var recurrence: Recurrence
    var workLoadEst: Int?
    
    init(name: String, description: String? = nil, date: Date? = nil, isCompleted: Bool, owner: Planet, reoccurence: Recurrence, workLoadEst: Int? = nil) {
        self.name = name
        self.descr = description
        self.date = date
        self.isCompleted = isCompleted
        self.owner = owner
        self.recurrence = reoccurence
        self.workLoadEst = workLoadEst
    }
    
    func complete(){
        isCompleted.toggle()
    }
    
    func update(name: String?, description: String?, date: Date?){
        self.name = name ?? self.name
        self.descr = description ?? self.descr
        self.date = date ?? self.date
    }
    
    func copy() -> Quest {
        let copy = Quest(
            name: self.name,
            description: self.descr,
            date: self.date,  // Will be updated below
            isCompleted: false,  // New quest starts incomplete
            owner: self.owner,
            reoccurence: self.recurrence,
            workLoadEst: self.workLoadEst
        )
        return copy
    }
}

enum Recurrence : String, CaseIterable, Identifiable, Codable{
    case None, Daily, Weekly, Monthly
    var id: String{ self.rawValue }
}

extension Quest { // Due Date View
    var formattedDate: String {
        guard let questDate = self.date else { return "" }
        
        let calendar = Calendar.current
        
        // 1. Exact Day Named Matches
        if calendar.isDateInToday(questDate) {
            return "Today"
        } else if calendar.isDateInTomorrow(questDate) {
            return "Tomorrow"
        } else if calendar.isDateInYesterday(questDate) {
            return "Yesterday"
        }
        
        // 2. Compute Day Difference for Past/Future Fallback
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfQuest = calendar.startOfDay(for: questDate)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfQuest)
        
        guard let days = components.day else { return "" }
        
        if days < 0 {
            let pastDays = abs(days)
            return "\(pastDays) days ago"
        } else {
            return "in \(days) days"
        }
    }
    
    var isOverdue: Bool {
        guard let questDate = self.date else { return false }
        return questDate < Date() && !Calendar.current.isDateInToday(questDate)
    }
}


