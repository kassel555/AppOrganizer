import SwiftUI
import SwiftData

struct AppLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AppItem.name) private var allApps: [AppItem]

    @State private var searchText = ""
    @State private var selectedCategory: AppCategory? = nil

    private var filteredApps: [AppItem] {
        var apps = allApps

        if let category = selectedCategory {
            apps = apps.filter { $0.defaultCategory == category.rawValue }
        }

        if !searchText.isEmpty {
            apps = apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        return apps
    }

    private var addedCount: Int {
        allApps.filter { $0.isAdded }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryChip(
                            title: "All",
                            icon: "square.grid.2x2",
                            isSelected: selectedCategory == nil,
                            color: .blue
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(AppCategory.allCases) { category in
                            CategoryChip(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: selectedCategory == category,
                                color: category.color
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(Color(.systemBackground))

                // App Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80), spacing: 16)
                    ], spacing: 20) {
                        ForEach(filteredApps) { app in
                            AppGridItemView(app: app) {
                                toggleApp(app)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Browse Apps")
            .searchable(text: $searchText, prompt: "Search \(allApps.count) apps")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(addedCount) added")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func toggleApp(_ app: AppItem) {
        app.isAdded.toggle()
        if app.isAdded {
            app.dateAdded = Date()
        } else {
            app.dateAdded = nil
            app.userCategory = nil
        }
    }
}

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button {
            HapticManager.selection()
            action()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                if isSelected {
                    Text(title)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, isSelected ? 12 : 10)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color(.systemGray5))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AppLibraryView()
}
