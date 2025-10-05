//
//  StatsView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📈 Statistics")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Text("Your cinema journey")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        // Stats Cards
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 12) {
                            StatCard(
                                icon: "film.stack",
                                value: "\(dataManager.totalTitles)",
                                label: "Total Titles",
                                gradient: [Color(hex: "667eea"), Color(hex: "764ba2")]
                            )
                            
                            StatCard(
                                icon: "checkmark.circle.fill",
                                value: "\(dataManager.watchedCount)",
                                label: "Watched",
                                gradient: [Color(hex: "00c9ff"), Color(hex: "92fe9d")]
                            )
                            
                            StatCard(
                                icon: "heart.fill",
                                value: "\(dataManager.favoritesCount)",
                                label: "Favorites",
                                gradient: [Color(hex: "f953c6"), Color(hex: "b91d73")]
                            )
                            
                            StatCard(
                                icon: "dice.fill",
                                value: "\(dataManager.rollsThisMonth)",
                                label: "Rolls This Month",
                                gradient: [Color(hex: "a8edea"), Color(hex: "fed6e3")]
                            )
                        }
                        
                        // Most Picked
                        if let mostPicked = dataManager.mostPickedTitle, mostPicked.rollCount > 0 {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Most Picked")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 16) {
                                    Text("🏆")
                                        .font(.system(size: 40))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(mostPicked.name)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                        Text("Picked \(mostPicked.rollCount) times")
                                            .font(.system(size: 14))
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(16)
                            }
                        }
                        
                        // Achievements
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Achievements")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(dataManager.unlockedAchievementsCount)/\(dataManager.achievements.count)")
                                    .font(.system(size: 17))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 12) {
                                ForEach(dataManager.achievements) { achievement in
                                    AchievementCard(achievement: achievement)
                                }
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 32)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.white)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Text(achievement.icon)
                .font(.system(size: 40))
            
            Text(achievement.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(achievement.description)
                .font(.system(size: 11))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if achievement.isUnlocked {
                if let date = achievement.unlockedDate {
                    Text(formatDate(date))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.green)
                }
            } else {
                Text(achievement.progressText)
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(achievement.isUnlocked ? AppColors.cardBackground : AppColors.cardBackground.opacity(0.5))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.isUnlocked ? .green.opacity(0.5) : Color.clear, lineWidth: 2)
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

