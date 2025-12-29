import Foundation
import SwiftData

@Model
final class AppFolder {
    var id: UUID
    var name: String
    var colorHex: String
    var order: Int

    @Relationship(deleteRule: .nullify)
    var apps: [AppItem]

    init(
        id: UUID = UUID(),
        name: String,
        colorHex: String,
        order: Int = 0,
        apps: [AppItem] = []
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.order = order
        self.apps = apps
    }
}
