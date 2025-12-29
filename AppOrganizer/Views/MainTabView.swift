import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AppLibraryView()
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            MyAppsView()
                .tabItem {
                    Label("My Apps", systemImage: "checkmark.circle.fill")
                }
                .tag(1)

            OrganizationPlanView()
                .tabItem {
                    Label("Organize", systemImage: "folder.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
}
