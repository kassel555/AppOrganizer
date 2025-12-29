import SwiftUI

struct AppRowView: View {
    let app: AppItem

    var body: some View {
        HStack(spacing: 12) {
            // App Icon
            RoundedRectangle(cornerRadius: 10)
                .fill(iconGradient)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: app.iconName)
                        .font(.title3)
                        .foregroundStyle(.white)
                }

            // App Info
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.body)

                if let dateAdded = app.dateAdded {
                    Text("Added \(dateAdded.formatted(.relative(presentation: .named)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Category indicator
            if let category = AppCategory.from(app.effectiveCategory) {
                Image(systemName: category.icon)
                    .font(.caption)
                    .foregroundStyle(category.color)
            }
        }
        .padding(.vertical, 4)
    }

    private var iconGradient: LinearGradient {
        let category = AppCategory.from(app.effectiveCategory)
        let color = category?.color ?? .blue
        return LinearGradient(
            colors: [color, color.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    List {
        AppRowView(
            app: AppItem(
                name: "Instagram",
                bundleId: "com.instagram",
                iconName: "camera.fill",
                defaultCategory: "Social Media",
                isAdded: true,
                dateAdded: Date()
            )
        )
        AppRowView(
            app: AppItem(
                name: "Netflix",
                bundleId: "com.netflix",
                iconName: "play.tv.fill",
                defaultCategory: "Entertainment",
                isAdded: true,
                dateAdded: Date().addingTimeInterval(-86400 * 3)
            )
        )
    }
}
