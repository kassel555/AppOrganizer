import SwiftUI

struct AppGridItemView: View {
    let app: AppItem
    let onTap: () -> Void

    var body: some View {
        Button {
            // Haptic feedback based on action
            if app.isAdded {
                HapticManager.light()
            } else {
                HapticManager.medium()
            }
            onTap()
        } label: {
            VStack(spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    // App Icon
                    RoundedRectangle(cornerRadius: 14)
                        .fill(iconGradient)
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: app.iconName)
                                .font(.title2)
                                .foregroundStyle(.white)
                        }

                    // Added badge
                    if app.isAdded {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.white, .green)
                            .offset(x: 4, y: -4)
                    }
                }

                // App Name
                Text(app.name)
                    .font(.caption2)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
            }
            .frame(width: 80)
        }
        .buttonStyle(.plain)
    }

    private var iconGradient: LinearGradient {
        let category = AppCategory.from(app.defaultCategory)
        let color = category?.color ?? .blue
        return LinearGradient(
            colors: [color, color.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    HStack {
        AppGridItemView(
            app: AppItem(
                name: "Instagram",
                bundleId: "com.instagram",
                iconName: "camera.fill",
                defaultCategory: "Social Media",
                isAdded: false
            )
        ) {}

        AppGridItemView(
            app: AppItem(
                name: "Netflix",
                bundleId: "com.netflix",
                iconName: "play.tv.fill",
                defaultCategory: "Entertainment",
                isAdded: true
            )
        ) {}
    }
}
