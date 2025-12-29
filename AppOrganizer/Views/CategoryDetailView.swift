import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    let category: AppCategory

    @Environment(\.modelContext) private var modelContext
    @Query private var allApps: [AppItem]

    private var categoryApps: [AppItem] {
        allApps.filter { $0.effectiveCategory == category.rawValue && $0.isAdded }
            .sorted { $0.name < $1.name }
    }

    var body: some View {
        List {
            ForEach(categoryApps) { app in
                AppRowView(app: app)
            }
            .onDelete(perform: removeApps)
        }
        .navigationTitle(category.rawValue)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(categoryApps.count) apps")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func removeApps(at offsets: IndexSet) {
        for index in offsets {
            let app = categoryApps[index]
            app.isAdded = false
            app.dateAdded = nil
            app.userCategory = nil
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: .socialMedia)
    }
}
