//
//  FavoritesView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var searchText = ""
    
    var favoriteTitles: [Title] {
        let favorites = dataManager.titles.filter { $0.isFavorite }
        if searchText.isEmpty {
            return favorites.sorted { $0.dateAdded > $1.dateAdded }
        } else {
            return favorites.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var unwatchedFavoritesCount: Int {
        dataManager.titles.filter { $0.isFavorite && !$0.isWatched }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("❤️ Favorites")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Text("\(unwatchedFavoritesCount) unwatched favorites")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.textSecondary)
                        TextField("Search favorites...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    if favoriteTitles.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(favoriteTitles) { title in
                                    FavoriteTitleCard(title: title)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        }
                    }
                    
                    Spacer()
                    
                    // Roll from Favorites
                    if !favoriteTitles.isEmpty {
                        Button(action: {
                            // Roll from favorites logic
                        }) {
                            HStack {
                                Image(systemName: "dice")
                                Text("Roll from Favorites")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.primary)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 80))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No favorites yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Add titles to favorites to see them here")
                .font(.system(size: 16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FavoriteTitleCard: View {
    let title: Title
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showEditSheet = false
    
    var body: some View {
        Button(action: {
            showEditSheet = true
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground.opacity(0.5))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: title.type == .film ? "film" : "tv")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primary)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(title.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(title.type.rawValue)
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.textSecondary)
                        
                        if !title.genres.isEmpty {
                            ForEach(title.genres.prefix(2), id: \.self) { genre in
                                Text(genre)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppColors.cardBackground)
                                    .foregroundColor(AppColors.textSecondary)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Status
                VStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primary)
                    
                    if title.isWatched {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
        }
        .sheet(isPresented: $showEditSheet) {
            EditTitleView(title: title)
        }
    }
}

