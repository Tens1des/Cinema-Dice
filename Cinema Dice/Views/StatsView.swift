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
                AppColors.background(dataManager.appTheme).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📈 Statistics")
                                .font(.dynamicSize(34, weight: .bold, textSize: dataManager.textSize))
                                .foregroundColor(AppColors.text(dataManager.appTheme))
                            Text("Your cinema journey")
                                .font(.dynamicSize(15, textSize: dataManager.textSize))
                                .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
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
                                    .font(.dynamicSize(20, weight: .bold, textSize: dataManager.textSize))
                                    .foregroundColor(AppColors.text(dataManager.appTheme))
                                
                                HStack(spacing: 16) {
                                    Text("🏆")
                                        .font(.system(size: 40 * dataManager.textSize.scale))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(mostPicked.name)
                                            .font(.dynamicSize(18, weight: .semibold, textSize: dataManager.textSize))
                                            .foregroundColor(AppColors.text(dataManager.appTheme))
                                        Text("Picked \(mostPicked.rollCount) times")
                                            .font(.dynamicSize(14, textSize: dataManager.textSize))
                                            .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(16)
                            }
                        }
                        
                        // Achievements
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Achievements")
                                    .font(.system(size: 20 * dataManager.textSize.scale, weight: .bold))
                                    .foregroundColor(AppColors.text(dataManager.appTheme))
                                
                                Spacer()
                                
                                Text("\(dataManager.unlockedAchievementsCount)/\(dataManager.achievements.count)")
                                    .font(.system(size: 17 * dataManager.textSize.scale))
                                    .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
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
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        VStack(spacing: 8) {
            Text(achievement.icon)
                .font(.dynamicSize(40, textSize: dataManager.textSize))
            
            Text(achievement.title)
                .font(.dynamicSize(14, weight: .semibold, textSize: dataManager.textSize))
                .foregroundColor(AppColors.text(dataManager.appTheme))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(achievement.description)
                .font(.dynamicSize(11, textSize: dataManager.textSize))
                .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if achievement.isUnlocked {
                if let date = achievement.unlockedDate {
                    Text(formatDate(date))
                        .font(.dynamicSize(11, weight: .medium, textSize: dataManager.textSize))
                        .foregroundColor(.green)
                }
            } else {
                Text(achievement.progressText)
                    .font(.dynamicSize(11, textSize: dataManager.textSize))
                    .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(achievement.isUnlocked ? AppColors.cardBackground(dataManager.appTheme) : AppColors.cardBackground(dataManager.appTheme).opacity(0.5))
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

