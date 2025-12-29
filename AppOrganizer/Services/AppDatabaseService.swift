import Foundation
import SwiftData

@MainActor
class AppDatabaseService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func seedDatabaseIfNeeded() throws {
        let descriptor = FetchDescriptor<AppItem>()
        let existingCount = try modelContext.fetchCount(descriptor)

        guard existingCount == 0 else { return }

        for app in PreloadedApps.all {
            let appItem = AppItem(
                name: app.name,
                bundleId: app.bundleId,
                iconName: app.icon,
                defaultCategory: app.category
            )
            modelContext.insert(appItem)
        }

        try modelContext.save()
    }

    func fetchAllApps() throws -> [AppItem] {
        let descriptor = FetchDescriptor<AppItem>(sortBy: [SortDescriptor(\.name)])
        return try modelContext.fetch(descriptor)
    }

    func fetchAddedApps() throws -> [AppItem] {
        let descriptor = FetchDescriptor<AppItem>(
            predicate: #Predicate { $0.isAdded == true },
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchApps(inCategory category: String) throws -> [AppItem] {
        let descriptor = FetchDescriptor<AppItem>(
            predicate: #Predicate { $0.defaultCategory == category },
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }

    func searchApps(query: String) throws -> [AppItem] {
        let descriptor = FetchDescriptor<AppItem>(
            predicate: #Predicate { $0.name.localizedStandardContains(query) },
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }

    func addApp(_ app: AppItem) {
        app.isAdded = true
        app.dateAdded = Date()
    }

    func removeApp(_ app: AppItem) {
        app.isAdded = false
        app.dateAdded = nil
        app.userCategory = nil
    }

    func changeCategory(_ app: AppItem, to category: String) {
        app.userCategory = category
    }
}
