import SwiftUI
import SwiftData

@main
struct AppOrganizerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AppItem.self,
            AppFolder.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Seed database with preloaded apps if empty
            let context = container.mainContext
            let descriptor = FetchDescriptor<AppItem>()
            let existingCount = try context.fetchCount(descriptor)

            if existingCount == 0 {
                for app in PreloadedApps.all {
                    let appItem = AppItem(
                        name: app.name,
                        bundleId: app.bundleId,
                        iconName: app.icon,
                        defaultCategory: app.category
                    )
                    context.insert(appItem)
                }
                try context.save()
            }

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
