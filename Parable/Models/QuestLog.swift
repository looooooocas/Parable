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
        
        guard let date = quest.date else { return }
        
        let nextOccurence = quest.copy()
        
        switch quest.recurrence {
        case .None:
            return
        case .Daily:
            nextOccurence.date = date.addingTimeInterval(60 * 60 * 24)
        case .Weekly:
            nextOccurence.date = date.addingTimeInterval(60 * 60 * 24 * 7)
        case .Monthly:
            guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date) else { return }
            nextOccurence.date = nextMonth
        }
        questLog.addQuest(nextOccurence)
    }
    
    func uncompleteQuest(_ quest: Quest){
        quest.isCompleted = false
    }
    
    func getActiveQuests(target: Planet? = nil) -> [Quest] {
        if target == nil {
            return questLog.quests
            .filter { !$0.isCompleted }
            .sorted {
                ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture)
            }
        }
        return questLog.quests
            .filter { $0.owner == target && !$0.isCompleted }
            .sorted {
                ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture)
            }
    }
    
    func getAllQuests(target: Planet? = nil) -> [Quest] {
        if target == nil {
            return quests.sorted { ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture) }
        } else {
            return quests.filter{ $0.owner == target } .sorted { ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture) }
        }
    }
    
    func getCompletedQuests(target: Planet? = nil) -> [Quest] {
        return getAllQuests(target: target).filter(\.self.isCompleted)
    }
    
    func getQuests(from planet: Planet) -> [Quest] {
        return getAllQuests().filter { $0.owner == planet }
    }
}
