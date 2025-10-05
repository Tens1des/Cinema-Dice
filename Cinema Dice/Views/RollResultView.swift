//
//  RollResultView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

struct RollResultView: View {
    let titles: [Title]
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Close Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Dice Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(AppColors.primary)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "dice.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 24)
                
                Text("Your pick is...")
                    .font(.system(size: 17))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.bottom, 32)
                
                // Result Card
                if titles.count == 1, let title = titles.first {
                    SingleResultCard(title: title)
                } else {
                    TabView(selection: $currentIndex) {
                        ForEach(0..<titles.count, id: \.self) { index in
                            SingleResultCard(title: titles[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 400)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.2.circlepath")
                            Text("Roll Again")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.primary)
                        .cornerRadius(16)
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Back to Library")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.cardBackground)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
}

struct SingleResultCard: View {
    let title: Title
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            // Movie Icon
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppColors.cardBackground)
                    .frame(width: 200, height: 200)
                
                Image(systemName: title.type == .film ? "film" : "tv")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primary)
            }
            
            // Title
            Text(title.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Text(title.type.rawValue)
                .font(.system(size: 15))
                .foregroundColor(AppColors.textSecondary)
            
            // Genres
            if !title.genres.isEmpty {
                HStack(spacing: 8) {
                    ForEach(title.genres.prefix(3), id: \.self) { genre in
                        Text(genre)
                            .font(.system(size: 13))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.cardBackground)
                            .foregroundColor(AppColors.textSecondary)
                            .cornerRadius(12)
                    }
                }
            }
            
            // Note
            if !title.note.isEmpty {
                Text(title.note)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineLimit(3)
            }
            
            // Actions
            HStack(spacing: 16) {
                ActionButton(
                    icon: title.isFavorite ? "heart.fill" : "heart",
                    title: "Favorite",
                    isActive: title.isFavorite
                ) {
                    dataManager.toggleFavorite(title.id)
                }
                
                ActionButton(
                    icon: title.isWatched ? "checkmark.circle.fill" : "checkmark.circle",
                    title: "Watched",
                    isActive: title.isWatched
                ) {
                    dataManager.toggleWatched(title.id)
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundColor(isActive ? .white : AppColors.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isActive ? AppColors.primary.opacity(0.3) : AppColors.cardBackground)
            .cornerRadius(12)
        }
    }
}

