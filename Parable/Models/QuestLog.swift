import Foundation
import SwiftData

@Observable
@MainActor
class QuestLog {
    private var modelContext: ModelContext
    var quests: [Quest] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fetchQuests()
    }
    
    /// Re-fetches all quests straight from the context to stay perfectly in sync
    func fetchQuests() {
        let descriptor = FetchDescriptor<Quest>()
        do {
            self.quests = try modelContext.fetch(descriptor)
        } catch {
            print("⚠️ Failed to load quest log from disk: \(error)")
            self.quests = []
        }
    }
    
    func addQuest(_ quest: Quest) {
        modelContext.insert(quest)
        try? modelContext.save()
        
        // Re-fetch clean list straight from SwiftData to avoid duplicates
        fetchQuests()
    }
    
    func deleteQuest(_ quest: Quest) {
        modelContext.delete(quest)
        try? modelContext.save()
        
        // Re-fetch to guarantee sync with database state
        fetchQuests()
    }
    
    func completeQuest(_ quest: Quest){
        quest.isCompleted = true
        quest.dateCompleted = Date()
        
        guard let date = quest.dateDue else { return }
        
        let nextOccurence = quest.copy()
        
        switch quest.recurrence {
        case .None:
            return
        case .Daily:
            nextOccurence.dateDue = date.addingTimeInterval(60 * 60 * 24)
        case .Weekly:
            nextOccurence.dateDue = date.addingTimeInterval(60 * 60 * 24 * 7)
        case .Monthly:
            guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date) else { return }
            nextOccurence.dateDue = nextMonth
        }
        questLog.addQuest(nextOccurence)
    }
    
    func uncompleteQuest(_ quest: Quest){ // Doesn't undo recurrence
        quest.isCompleted = false
        quest.dateCompleted = nil
    }
    
    func getActiveQuests(target: Planet? = nil) -> [Quest] {
        if target == nil {
            return questLog.quests
            .filter { !$0.isCompleted }
            .sorted {
                ($0.dateDue ?? .distantFuture) < ($1.dateDue ?? .distantFuture)
            }
        }
        return questLog.quests
            .filter { $0.owner == target && !$0.isCompleted }
            .sorted {
                ($0.dateDue ?? .distantFuture) < ($1.dateDue ?? .distantFuture)
            }
    }
    
    func getAllQuests(target: Planet? = nil) -> [Quest] {
        if target == nil {
            return quests.sorted { ($0.dateDue ?? .distantFuture) < ($1.dateDue ?? .distantFuture) }
        } else {
            return quests.filter{ $0.owner == target } .sorted { ($0.dateDue ?? .distantFuture) < ($1.dateDue ?? .distantFuture) }
        }
    }
    
    func getCompletedQuests(target: Planet? = nil) -> [Quest] {
        return getAllQuests(target: target).filter(\.self.isCompleted)
    }
    
    func getQuests(from planet: Planet) -> [Quest] {
        return getAllQuests().filter { $0.owner == planet }
    }
    
    // Performance Statistics
    
    /// Returns quests whose dateDue, creation, or completion falls within [from, to]
    /// - Parameters:
    ///   - from: start of window (inclusive)
    ///   - to: end of window (inclusive)
    ///   - planet: optional planet filter
    ///   - by: which date to evaluate for inclusion
    enum QuestTimeDimension { case dueDate, created, completed }
    
    func getQuestsInTimeframe(from: Date, to: Date, planet: Planet? = nil, by: QuestTimeDimension) -> [Quest] {
        return quests.filter { q in
            if let planet = planet, q.owner != planet { return false }
            switch by {
            case .dueDate:
                guard let d = q.dateDue else { return false }
                return d >= from && d <= to
            case .created:
                let d = q.dateCreated
                return d >= from && d <= to
            case .completed:
                guard let d = q.dateCompleted else { return false }
                return d >= from && d <= to
            }
        }
    }
    
    /// Delta = quests added - quests completed within [windowStart, to].
    /// Defaults to a sliding 7-day window ending at `to`; `from` acts as a lower bound override.
    func getDelta(on planet: Planet, from: Date, to: Date) -> Int {
        // Define a 1-week sliding window ending at `to`.
        let windowStart = max(from, Calendar.current.date(byAdding: .day, value: -7, to: to) ?? from)
        let created = getQuestsInTimeframe(from: windowStart, to: to, planet: planet, by: .created).count
        let completed = getQuestsInTimeframe(from: windowStart, to: to, planet: planet, by: .completed).count
        return created - completed
    }
    
    /// Velocity = average days from creation to completion for quests completed within [windowStart, to].
    /// Defaults to a sliding 7-day window ending at `to`; `from` acts as a lower bound override.
    /// Uncompleted quests are ignored. Filtered by planet.
    func getVelocity(on planet: Planet, from: Date, to: Date) -> Double {
        let windowStart = max(from, Calendar.current.date(byAdding: .day, value: -7, to: to) ?? from)
        let completedQuests = getQuestsInTimeframe(from: windowStart, to: to, planet: planet, by: .completed)
        guard !completedQuests.isEmpty else { return 0.0 }
        let totalDays: Double = completedQuests.reduce(0.0) { sum, q in
            guard let completed = q.dateCompleted else { return sum }
            let created = q.dateCreated
            let interval = completed.timeIntervalSince(created)
            let days = interval / (60 * 60 * 24)
            return sum + max(days, 0)
        }
        return totalDays / Double(completedQuests.count)
    }
    
    /// Risk = average days before deadline from completion for quests completed within [windowStart, to].
    /// Defaults to a sliding 7-day window ending at `to`; `from` acts as a lower bound override.
    /// Positive values mean average completion before due date; negative values indicate lateness.
    func getRisk(on planet: Planet, from: Date, to: Date) -> Double {
        let windowStart = max(from, Calendar.current.date(byAdding: .day, value: -7, to: to) ?? from)
        let completedQuests = getQuestsInTimeframe(from: windowStart, to: to, planet: planet, by: .completed)
        // Consider only quests that have a due date to compare against
        let samples: [Double] = completedQuests.compactMap { q in
            guard let completed = q.dateCompleted, let due = q.dateDue else { return nil }
            let interval = due.timeIntervalSince(completed) // positive if completed before due
            return interval / (60 * 60 * 24)
        }
        guard !samples.isEmpty else { return 0.0 }
        let total = samples.reduce(0.0, +)
        return total / Double(samples.count)
    }
    
}
