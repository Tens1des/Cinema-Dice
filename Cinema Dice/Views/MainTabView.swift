//
//  MainTabView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryView()
                .tabItem {
                    Image(systemName: "film.stack")
                    Text("Library")
                }
                .tag(0)
            
            RollView()
                .tabItem {
                    Image(systemName: "dice")
                    Text("Roll")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(2)
            
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.primary)
        .preferredColorScheme(dataManager.appTheme == .dark ? .dark : .light)
    }
}

