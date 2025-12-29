import SwiftUI
import SwiftData

struct MyAppsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<AppItem> { $0.isAdded == true }, sort: \AppItem.name)
    private var addedApps: [AppItem]

    @State private var expandedCategories: Set<String> = Set(AppCategory.allCases.map { $0.rawValue })

    private var groupedApps: [(category: String, apps: [AppItem])] {
        let grouped = Dictionary(grouping: addedApps) { $0.effectiveCategory }
        return grouped.sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if addedApps.isEmpty {
                    EmptyMyAppsView()
                } else {
                    List {
                        ForEach(groupedApps, id: \.category) { group in
                            Section(isExpanded: Binding(
                                get: { expandedCategories.contains(group.category) },
                                set: { isExpanded in
                                    if isExpanded {
                                        expandedCategories.insert(group.category)
                                    } else {
                                        expandedCategories.remove(group.category)
                                    }
                                }
                            )) {
                                ForEach(group.apps) { app in
                                    AppRowView(app: app)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                removeApp(app)
                                            } label: {
                                                Label("Remove", systemImage: "trash")
                                            }
                                        }
                                        .contextMenu {
                                            categoryMenu(for: app)
                                        }
                                }
                            } header: {
                                CategorySectionHeader(
                                    category: group.category,
                                    count: group.apps.count
                                )
                            }
                        }
                    }
                    .listStyle(.sidebar)
                }
            }
            .navigationTitle("My Apps")
            .toolbar {
                if !addedApps.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("\(addedApps.count) apps")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func categoryMenu(for app: AppItem) -> some View {
        Menu("Move to Category") {
            ForEach(AppCategory.allCases) { category in
                Button {
                    HapticManager.success()
                    app.userCategory = category.rawValue
                } label: {
                    Label(category.rawValue, systemImage: category.icon)
                }
            }
        }
        Button(role: .destructive) {
            removeApp(app)
        } label: {
            Label("Remove from My Apps", systemImage: "trash")
        }
    }

    private func removeApp(_ app: AppItem) {
        HapticManager.warning()
        app.isAdded = false
        app.dateAdded = nil
        app.userCategory = nil
    }
}

struct CategorySectionHeader: View {
    let category: String
    let count: Int

    var categoryEnum: AppCategory? {
        AppCategory.from(category)
    }

    var body: some View {
        HStack {
            if let cat = categoryEnum {
                Image(systemName: cat.icon)
                    .foregroundStyle(cat.color)
            }
            Text(category)
            Spacer()
            Text("\(count)")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}

struct EmptyMyAppsView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No Apps Added", systemImage: "app.badge.checkmark")
        } description: {
            Text("Browse the app library and tap apps to add them to your collection.")
        } actions: {
            Text("Go to Browse tab")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    MyAppsView()
}
