import Foundation
import SwiftUI

enum AppCategory: String, CaseIterable, Identifiable {
    case socialMedia = "Social Media"
    case productivity = "Productivity"
    case entertainment = "Entertainment"
    case games = "Games"
    case finance = "Finance"
    case healthFitness = "Health & Fitness"
    case shopping = "Shopping"
    case travel = "Travel"
    case foodDrink = "Food & Drink"
    case utilities = "Utilities"
    case education = "Education"
    case news = "News"
    case photography = "Photography"
    case music = "Music"
    case lifestyle = "Lifestyle"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .socialMedia: return "bubble.left.and.bubble.right.fill"
        case .productivity: return "checkmark.circle.fill"
        case .entertainment: return "tv.fill"
        case .games: return "gamecontroller.fill"
        case .finance: return "dollarsign.circle.fill"
        case .healthFitness: return "heart.fill"
        case .shopping: return "cart.fill"
        case .travel: return "airplane"
        case .foodDrink: return "fork.knife"
        case .utilities: return "wrench.and.screwdriver.fill"
        case .education: return "book.fill"
        case .news: return "newspaper.fill"
        case .photography: return "camera.fill"
        case .music: return "music.note"
        case .lifestyle: return "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .socialMedia: return .blue
        case .productivity: return .orange
        case .entertainment: return .purple
        case .games: return .red
        case .finance: return .green
        case .healthFitness: return .pink
        case .shopping: return .yellow
        case .travel: return .cyan
        case .foodDrink: return .orange
        case .utilities: return .gray
        case .education: return .indigo
        case .news: return .red
        case .photography: return .purple
        case .music: return .pink
        case .lifestyle: return .mint
        }
    }

    static func from(_ string: String) -> AppCategory? {
        AppCategory.allCases.first { $0.rawValue == string }
    }
}
