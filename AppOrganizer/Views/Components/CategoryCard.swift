import SwiftUI

struct CategoryCard: View {
    let category: AppCategory
    let appCount: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: category.icon)
                        .font(.title2)
                        .foregroundStyle(category.color)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }

                Spacer()

                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)

                    Text("\(appCount) apps")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(height: 100)
            .background(isSelected ? category.color.opacity(0.1) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(category.color, lineWidth: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        CategoryCard(
            category: .socialMedia,
            appCount: 12,
            isSelected: false
        ) {}

        CategoryCard(
            category: .productivity,
            appCount: 8,
            isSelected: true
        ) {}

        CategoryCard(
            category: .entertainment,
            appCount: 15,
            isSelected: false
        ) {}

        CategoryCard(
            category: .games,
            appCount: 25,
            isSelected: false
        ) {}
    }
    .padding()
}
