import Foundation

struct OrganizationSuggestion {
    let folderName: String
    let category: AppCategory
    let apps: [AppItem]
    let tip: String?
}

class CategorySuggestionService {

    func generateSuggestions(for apps: [AppItem]) -> [OrganizationSuggestion] {
        let grouped = Dictionary(grouping: apps) { $0.effectiveCategory }

        return grouped.compactMap { categoryName, categoryApps in
            guard let category = AppCategory.from(categoryName) else { return nil }

            let tip = generateTip(for: category, appCount: categoryApps.count)

            return OrganizationSuggestion(
                folderName: categoryName,
                category: category,
                apps: categoryApps.sorted { $0.name < $1.name },
                tip: tip
            )
        }
        .sorted { $0.apps.count > $1.apps.count }
    }

    private func generateTip(for category: AppCategory, appCount: Int) -> String? {
        if appCount > 12 {
            return "Consider splitting into sub-folders for easier access"
        }

        switch category {
        case .socialMedia:
            return appCount > 5 ? "Keep your most-used social apps on the home screen" : nil
        case .productivity:
            return "Group work apps in one folder for focus time"
        case .games:
            return appCount > 8 ? "Create separate folders for different game genres" : nil
        case .entertainment:
            return "Keep streaming apps together for movie night"
        case .finance:
            return "Consider a dedicated folder on the second home screen for privacy"
        case .healthFitness:
            return "Keep fitness apps accessible for daily routines"
        default:
            return nil
        }
    }

    func suggestHomeScreenLayout(for apps: [AppItem]) -> HomeScreenLayout {
        let suggestions = generateSuggestions(for: apps)

        // Determine which folders should be on the first home screen
        let primaryFolders = suggestions
            .filter { folder in
                let isPrimary = [
                    AppCategory.socialMedia,
                    AppCategory.productivity,
                    AppCategory.entertainment,
                    AppCategory.utilities
                ].contains(folder.category)
                return isPrimary || folder.apps.count >= 5
            }
            .prefix(4)

        let secondaryFolders = suggestions.filter { folder in
            !primaryFolders.contains(where: { $0.folderName == folder.folderName })
        }

        return HomeScreenLayout(
            primaryFolders: Array(primaryFolders),
            secondaryFolders: Array(secondaryFolders),
            totalApps: apps.count
        )
    }
}

struct HomeScreenLayout {
    let primaryFolders: [OrganizationSuggestion]
    let secondaryFolders: [OrganizationSuggestion]
    let totalApps: Int

    var summary: String {
        """
        Suggested Home Screen Layout:
        - First screen: \(primaryFolders.count) folders (\(primaryFolders.map(\.folderName).joined(separator: ", ")))
        - Second screen: \(secondaryFolders.count) folders
        - Total apps organized: \(totalApps)
        """
    }
}
