//
//  LibraryView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Binding var selectedTab: Int
    @State private var searchText = ""
    @State private var showAddTitle = false
    @State private var showFilterSheet = false
    @State private var selectedGenres: Set<String> = []
    
    var filteredTitles: [Title] {
        let filtered = dataManager.titles.filter { title in
            let matchesSearch = searchText.isEmpty || title.name.lowercased().contains(searchText.lowercased())
            let matchesGenre = selectedGenres.isEmpty || !Set(title.genres).isDisjoint(with: selectedGenres)
            return matchesSearch && matchesGenre
        }
        return filtered.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var unwatchedCount: Int {
        dataManager.titles.filter { !$0.isWatched }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background(dataManager.appTheme).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                        Text("My Cinema")
                            .font(.dynamicSize(34, weight: .bold, textSize: dataManager.textSize))
                            .foregroundColor(AppColors.text(dataManager.appTheme))
                        Text("\(unwatchedCount) unwatched titles")
                            .font(.dynamicSize(15, textSize: dataManager.textSize))
                            .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                        }
                        Spacer()
                        
                        Button(action: {
                            showAddTitle = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(AppColors.primary)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Search and Filter
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppColors.textSecondary)
                            TextField("Search titles...", text: $searchText)
                                .foregroundColor(AppColors.text(dataManager.appTheme))
                        }
                        .padding(12)
                        .background(AppColors.cardBackground(dataManager.appTheme))
                        .cornerRadius(12)
                        
                        Button(action: {
                            showFilterSheet = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    if filteredTitles.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredTitles) { title in
                                    TitleCardView(title: title)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        }
                    }
                    
                    Spacer()
                    
                    // Roll Button
                    if !dataManager.titles.isEmpty {
                        Button(action: {
                            selectedTab = 1 // Switch to Roll tab
                        }) {
                            HStack {
                                Image(systemName: "dice.fill")
                                Text("Roll the Dice")
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
            .sheet(isPresented: $showAddTitle) {
                AddTitleView()
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheet(selectedGenres: $selectedGenres)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "film.stack")
                .font(.system(size: 80))
                .foregroundColor(AppColors.textSecondary)
            
                            Text("No titles yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.text(dataManager.appTheme))
            
            Text("Add your first movie or series\nto get started")
                .font(.system(size: 16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showAddTitle = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Title")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(AppColors.primary)
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TitleCardView: View {
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
                        .fill(AppColors.cardBackground(dataManager.appTheme))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: title.type == .film ? "film" : "tv")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primary)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(title.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppColors.text(dataManager.appTheme))
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
                                    .background(AppColors.cardBackground(dataManager.appTheme))
                                    .foregroundColor(AppColors.textSecondary)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: 8) {
                    Button(action: {
                        showEditSheet = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Button(action: {
                        dataManager.toggleFavorite(title.id)
                    }) {
                        Image(systemName: title.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                            .foregroundColor(title.isFavorite ? AppColors.primary : AppColors.textSecondary)
                    }
                    
                    Button(action: {
                        dataManager.toggleWatched(title.id)
                    }) {
                        Image(systemName: title.isWatched ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.system(size: 20))
                            .foregroundColor(title.isWatched ? .green : AppColors.textSecondary)
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardBackground(dataManager.appTheme))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(showEditSheet ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: showEditSheet)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.clear, lineWidth: 1)
        )
        .onTapGesture {
            showEditSheet = true
        }
        .sheet(isPresented: $showEditSheet) {
            EditTitleView(title: title)
        }
    }
}

struct FilterSheet: View {
    @Binding var selectedGenres: Set<String>
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var allGenres: [String] {
        let genres = Set(dataManager.titles.flatMap { $0.genres })
        return Array(genres).sorted()
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Done Button
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        Text("Filter by Genre")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                        
                        ForEach(allGenres, id: \.self) { genre in
                            Button(action: {
                                if selectedGenres.contains(genre) {
                                    selectedGenres.remove(genre)
                                } else {
                                    selectedGenres.insert(genre)
                                }
                            }) {
                                HStack {
                                    Text(genre)
                                        .font(.system(size: 17))
                                        .foregroundColor(.white)
                                    Spacer()
                                    if selectedGenres.contains(genre) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(AppColors.primary)
                                    }
                                }
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(12)
                            }
                        }
                        
                        if !selectedGenres.isEmpty {
                            Button(action: {
                                selectedGenres.removeAll()
                            }) {
                                Text("Clear All")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(AppColors.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(AppColors.cardBackground(dataManager.appTheme))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(20)
                    .padding(.top, 16)
                }
            }
        }
    }
}

#Preview {
    LibraryView(selectedTab: .constant(0))
}

