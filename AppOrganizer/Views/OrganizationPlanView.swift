import SwiftUI
import SwiftData

struct OrganizationPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<AppItem> { $0.isAdded == true }, sort: \AppItem.name)
    private var addedApps: [AppItem]

    @State private var showingShareSheet = false
    @State private var organizationText = ""

    private var groupedApps: [(category: String, apps: [AppItem])] {
        let grouped = Dictionary(grouping: addedApps) { $0.effectiveCategory }
        return grouped.sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
    }

    private var suggestedFolders: [(name: String, icon: String, color: Color, appCount: Int)] {
        groupedApps.compactMap { group in
            guard let category = AppCategory.from(group.category) else { return nil }
            return (
                name: group.category,
                icon: category.icon,
                color: category.color,
                appCount: group.apps.count
            )
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if addedApps.isEmpty {
                    EmptyOrganizationView()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Stats Section
                            StatsSection(
                                totalApps: addedApps.count,
                                totalFolders: suggestedFolders.count
                            )

                            // Suggested Folders
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Suggested Folders")
                                    .font(.headline)
                                    .padding(.horizontal)

                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 12) {
                                    ForEach(suggestedFolders, id: \.name) { folder in
                                        FolderCard(
                                            name: folder.name,
                                            icon: folder.icon,
                                            color: folder.color,
                                            appCount: folder.appCount
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }

                            // Tips Section
                            TipsSection()

                            // Detailed List
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your Organization Plan")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ForEach(groupedApps, id: \.category) { group in
                                    if let category = AppCategory.from(group.category) {
                                        FolderDetailCard(
                                            category: category,
                                            apps: group.apps
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Organize")
            .toolbar {
                if !addedApps.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        ShareLink(item: generateShareText()) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
    }

    private func generateShareText() -> String {
        var text = "My iPhone App Organization Plan\n"
        text += "================================\n\n"
        text += "Total Apps: \(addedApps.count)\n"
        text += "Suggested Folders: \(suggestedFolders.count)\n\n"

        for group in groupedApps {
            text += "\(group.category) (\(group.apps.count) apps)\n"
            for app in group.apps {
                text += "  - \(app.name)\n"
            }
            text += "\n"
        }

        text += "\nGenerated with App Organizer"
        return text
    }
}

struct StatsSection: View {
    let totalApps: Int
    let totalFolders: Int

    var body: some View {
        HStack(spacing: 16) {
            StatCard(value: "\(totalApps)", label: "Apps", icon: "app.fill", color: .blue)
            StatCard(value: "\(totalFolders)", label: "Folders", icon: "folder.fill", color: .orange)
            StatCard(value: "\(totalApps / max(totalFolders, 1))", label: "Avg/Folder", icon: "square.grid.2x2", color: .green)
        }
        .padding(.horizontal)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.primary)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct FolderCard: View {
    let name: String
    let icon: String
    let color: Color
    let appCount: Int

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Spacer()
                Text("\(appCount)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(Capsule())
            }
            Text(name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct FolderDetailCard: View {
    let category: AppCategory
    let apps: [AppItem]

    @State private var isExpanded = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                HapticManager.light()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: category.icon)
                        .foregroundStyle(category.color)
                    Text(category.rawValue)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(apps.count) apps")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(apps.prefix(10)) { app in
                        HStack(spacing: 8) {
                            Image(systemName: app.iconName)
                                .font(.caption)
                                .foregroundStyle(category.color.opacity(0.8))
                                .frame(width: 20)
                            Text(app.name)
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                    }
                    if apps.count > 10 {
                        Text("+ \(apps.count - 10) more")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal)
    }
}

struct TipsSection: View {
    let tips = [
        ("lightbulb.fill", "Group similar apps together for faster access"),
        ("hand.tap.fill", "Keep frequently used apps on your first home screen"),
        ("folder.fill", "Limit folders to 9-12 apps for easy browsing"),
        ("sparkles", "Use the App Library for apps you rarely use")
    ]

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Organization Tips")
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.horizontal)

            VStack(spacing: 10) {
                ForEach(tips, id: \.0) { tip in
                    HStack(spacing: 12) {
                        Image(systemName: tip.0)
                            .font(.callout)
                            .foregroundStyle(.orange)
                            .frame(width: 24)
                        Text(tip.1)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }
}

struct EmptyOrganizationView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No Organization Plan", systemImage: "folder.badge.questionmark")
        } description: {
            Text("Add apps to your collection first, then come back to see organization suggestions.")
        }
    }
}

#Preview {
    OrganizationPlanView()
}
