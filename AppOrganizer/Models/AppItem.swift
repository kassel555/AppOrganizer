import Foundation
import SwiftData

@Model
final class AppItem {
    var id: UUID
    var name: String
    var bundleId: String
    var iconName: String
    var defaultCategory: String
    var isAdded: Bool
    var userCategory: String?
    var dateAdded: Date?

    init(
        id: UUID = UUID(),
        name: String,
        bundleId: String,
        iconName: String,
        defaultCategory: String,
        isAdded: Bool = false,
        userCategory: String? = nil,
        dateAdded: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.bundleId = bundleId
        self.iconName = iconName
        self.defaultCategory = defaultCategory
        self.isAdded = isAdded
        self.userCategory = userCategory
        self.dateAdded = dateAdded
    }

    var effectiveCategory: String {
        userCategory ?? defaultCategory
    }
}
