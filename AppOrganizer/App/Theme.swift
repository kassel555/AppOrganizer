import SwiftUI

// MARK: - App Theme Colors
extension Color {
    // Adaptive background colors
    static let cardBackground = Color(.secondarySystemBackground)
    static let elevatedBackground = Color(.tertiarySystemBackground)

    // Adaptive text colors
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let tertiaryText = Color(.tertiaryLabel)

    // Adaptive UI element colors
    static let separator = Color(.separator)
    static let border = Color(.systemGray4)
}

// MARK: - View Extensions for Dark Mode
extension View {
    func cardStyle() -> some View {
        self
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    func elevatedCardStyle() -> some View {
        self
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Dark Mode Aware Gradient
extension LinearGradient {
    static func adaptiveGradient(for color: Color) -> LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.75)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
