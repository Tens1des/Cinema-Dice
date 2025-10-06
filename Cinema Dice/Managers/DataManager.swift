//
//  DataManager.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var titles: [Title] = []
    @Published var achievements: [Achievement] = Achievement.allAchievements
    @Published var userProfile: UserProfile = UserProfile()
    @Published var appTheme: AppTheme = .dark
    @Published var appLanguage: AppLanguage = .english
    @Published var textSize: TextSize = .medium
    @Published var rollsThisMonth: Int = 0
    
    // New achievement tracking
    @Published var nightRollsCount: Int = 0
    @Published var morningRollsCount: Int = 0
    @Published var watchedInRowCount: Int = 0
    @Published var contentTypesTried: Set<String> = []
    
    private let titlesKey = "cinema_dice_titles"
    private let achievementsKey = "cinema_dice_achievements"
    private let profileKey = "cinema_dice_profile"
    private let themeKey = "cinema_dice_theme"
    private let languageKey = "cinema_dice_language"
    private let textSizeKey = "cinema_dice_text_size"
    private let rollsMonthKey = "cinema_dice_rolls_month"
    private let lastMonthKey = "cinema_dice_last_month"
    private let nightRollsKey = "cinema_dice_night_rolls"
    private let morningRollsKey = "cinema_dice_morning_rolls"
    private let watchedInRowKey = "cinema_dice_watched_in_row"
    private let contentTypesKey = "cinema_dice_content_types"
    
    init() {
        // Reset achievements to include new ones
        achievements = Achievement.allAchievements
        loadData()
        checkAndResetMonthlyRolls()
        
        // Clean corrupted data on startup
        cleanCorruptedData()
    }
    
    // MARK: - Save/Load
    
    func saveData() {
        saveTitles()
        saveAchievements()
        saveProfile()
        saveSettings()
    }
    
    func loadData() {
        loadTitles()
        loadAchievements()
        loadProfile()
        loadSettings()
    }
    
    private func saveTitles() {
        if let encoded = try? JSONEncoder().encode(titles) {
            UserDefaults.standard.set(encoded, forKey: titlesKey)
        }
    }
    
    private func loadTitles() {
        if let data = UserDefaults.standard.data(forKey: titlesKey),
           let decoded = try? JSONDecoder().decode([Title].self, from: data) {
            titles = decoded
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            
            // Merge saved achievements with new ones
            var mergedAchievements = Achievement.allAchievements
            
            for savedAchievement in decoded {
                if let index = mergedAchievements.firstIndex(where: { $0.id == savedAchievement.id }) {
                    mergedAchievements[index] = savedAchievement
                }
            }
            
            achievements = mergedAchievements
        }
    }
    
    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decoded
        }
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(appTheme.rawValue, forKey: themeKey)
        UserDefaults.standard.set(appLanguage.rawValue, forKey: languageKey)
        UserDefaults.standard.set(textSize.rawValue, forKey: textSizeKey)
        UserDefaults.standard.set(rollsThisMonth, forKey: rollsMonthKey)
        UserDefaults.standard.set(nightRollsCount, forKey: nightRollsKey)
        UserDefaults.standard.set(morningRollsCount, forKey: morningRollsKey)
        UserDefaults.standard.set(watchedInRowCount, forKey: watchedInRowKey)
        if let encoded = try? JSONEncoder().encode(contentTypesTried) {
            UserDefaults.standard.set(encoded, forKey: contentTypesKey)
        }
    }
    
    private func loadSettings() {
        if let themeString = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: themeString) {
            appTheme = theme
        }
        if let languageString = UserDefaults.standard.string(forKey: languageKey),
           let language = AppLanguage(rawValue: languageString) {
            appLanguage = language
        }
        if let sizeString = UserDefaults.standard.string(forKey: textSizeKey),
           let size = TextSize(rawValue: sizeString) {
            textSize = size
        }
        rollsThisMonth = UserDefaults.standard.integer(forKey: rollsMonthKey)
        nightRollsCount = UserDefaults.standard.integer(forKey: nightRollsKey)
        morningRollsCount = UserDefaults.standard.integer(forKey: morningRollsKey)
        watchedInRowCount = UserDefaults.standard.integer(forKey: watchedInRowKey)
        if let data = UserDefaults.standard.data(forKey: contentTypesKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            contentTypesTried = decoded
        }
    }
    
    // MARK: - Title Management
    
    func addTitle(_ title: Title) {
        titles.append(title)
        saveTitles()
        checkAchievements()
    }
    
    func updateTitle(_ title: Title) {
        if let index = titles.firstIndex(where: { $0.id == title.id }) {
            titles[index] = title
            saveTitles()
            checkAchievements()
        }
    }
    
    func deleteTitle(_ title: Title) {
        titles.removeAll { $0.id == title.id }
        saveTitles()
    }
    
    func toggleFavorite(_ titleId: UUID) {
        if let index = titles.firstIndex(where: { $0.id == titleId }) {
            titles[index].isFavorite.toggle()
            saveTitles()
            checkAchievements()
        }
    }
    
    func toggleWatched(_ titleId: UUID) {
        if let index = titles.firstIndex(where: { $0.id == titleId }) {
            let wasWatched = titles[index].isWatched
            titles[index].isWatched.toggle()
            
            // Track watched in row for perfectionist achievement
            if !wasWatched && titles[index].isWatched {
                watchedInRowCount += 1
            } else if wasWatched && !titles[index].isWatched {
                watchedInRowCount = 0 // Reset if unwatched
            }
            
            saveTitles()
            saveSettings()
            checkAchievements()
        }
    }
    
    func incrementRollCount(for titleId: UUID) {
        if let index = titles.firstIndex(where: { $0.id == titleId }) {
            titles[index].rollCount += 1
            titles[index].lastRolled = Date()
            saveTitles()
        }
    }
    
    // MARK: - Statistics
    
    var totalTitles: Int {
        titles.count
    }
    
    var watchedCount: Int {
        titles.filter { $0.isWatched }.count
    }
    
    var favoritesCount: Int {
        titles.filter { $0.isFavorite }.count
    }
    
    var mostPickedTitle: Title? {
        titles.max(by: { $0.rollCount < $1.rollCount })
    }
    
    var unlockedAchievementsCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    // MARK: - Roll Management
    
    func recordRoll(contentType: String = "") {
        rollsThisMonth += 1
        userProfile.totalRolls += 1
        
        // Track time-based achievements
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        if hour >= 22 || hour <= 2 { // Night time (10 PM - 2 AM)
            nightRollsCount += 1
        } else if hour >= 5 && hour <= 8 { // Morning time (5 AM - 8 AM)
            morningRollsCount += 1
        }
        
        // Track content types
        if !contentType.isEmpty {
            contentTypesTried.insert(contentType)
        }
        
        // Update streak
        if let lastRoll = userProfile.lastRollDate {
            let daysSinceLastRoll = calendar.dateComponents([.day], from: lastRoll, to: Date()).day ?? 0
            if daysSinceLastRoll == 1 {
                userProfile.rollStreak += 1
            } else if daysSinceLastRoll > 1 {
                userProfile.rollStreak = 1
            }
        } else {
            userProfile.rollStreak = 1
        }
        
        userProfile.lastRollDate = Date()
        saveProfile()
        saveSettings()
        checkAchievements()
    }
    
    private func checkAndResetMonthlyRolls() {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let lastMonth = UserDefaults.standard.integer(forKey: lastMonthKey)
        
        if lastMonth != currentMonth {
            rollsThisMonth = 0
            UserDefaults.standard.set(currentMonth, forKey: lastMonthKey)
            saveSettings()
        }
    }
    
    // MARK: - Achievements
    
    func checkAchievements() {
        updateAchievement(.movieBuff, progress: totalTitles)
        updateAchievement(.tastemaker, progress: favoritesCount)
        updateAchievement(.firstWatched, progress: watchedCount > 0 ? 1 : 0)
        updateAchievement(.bingeWatcher, progress: watchedCount)
        updateAchievement(.curator, progress: totalTitles)
        updateAchievement(.lucky7, progress: userProfile.rollStreak)
        
        let notesCount = titles.filter { !$0.note.isEmpty }.count
        updateAchievement(.noteWriter, progress: notesCount > 0 ? 1 : 0)
        
        let genresSet = Set(titles.flatMap { $0.genres })
        updateAchievement(.genreMaster, progress: genresSet.count)
        
        // New achievements
        updateAchievement(.nightOwl, progress: nightRollsCount)
        updateAchievement(.earlyBird, progress: morningRollsCount)
        updateAchievement(.perfectionist, progress: watchedInRowCount)
        updateAchievement(.explorer, progress: contentTypesTried.count)
        updateAchievement(.socialButterfly, progress: notesCount)
        
        saveAchievements()
    }
    
    func unlockAchievement(_ type: AchievementType) {
        if let index = achievements.firstIndex(where: { $0.id == type }) {
            if !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
                achievements[index].progress = achievements[index].maxProgress
                saveAchievements()
            }
        }
    }
    
    func updateAchievement(_ type: AchievementType, progress: Int) {
        if let index = achievements.firstIndex(where: { $0.id == type }) {
            achievements[index].progress = min(progress, achievements[index].maxProgress)
            if achievements[index].progress >= achievements[index].maxProgress && !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
            }
            saveAchievements()
        }
    }
    
    // MARK: - Reset
    
    func resetAllData() {
        titles = []
        achievements = Achievement.allAchievements
        userProfile = UserProfile()
        rollsThisMonth = 0
        saveData()
    }
    
    func cleanCorruptedData() {
        // Remove titles with invalid names
        titles.removeAll { title in
            title.name.isEmpty || 
            title.name == "ВФВФВ" || 
            title.name == "ФВФВФВ" ||
            title.name.count < 2
        }
        
        // Clean corrupted notes
        for i in 0..<titles.count {
            if titles[i].note == "ФВФВФВ" || titles[i].note == "ВФВФВ" {
                titles[i].note = ""
            }
        }
        
        saveData()
    }
    
    // MARK: - Sample Data
    
    func loadSampleData() {
        let sampleTitles = [
            Title(name: "Inception", type: .film, genres: ["Sci-Fi", "Thriller", "Mind-Bending"], note: "A thief who steals corporate secrets through dream-sharing technology.", isFavorite: true, isWatched: true),
            Title(name: "The Shawshank Redemption", type: .film, genres: ["Drama"], note: "", isFavorite: true, isWatched: true),
            Title(name: "The Office", type: .series, genres: ["Comedy"], note: "", isFavorite: true, isWatched: false),
            Title(name: "Breaking Bad", type: .series, genres: ["Drama", "Crime"], note: "", isFavorite: false, isWatched: true),
            Title(name: "Dark", type: .series, genres: ["Sci-Fi", "Mystery"], note: "", isFavorite: false, isWatched: false),
            Title(name: "Parasite", type: .film, genres: ["Thriller", "Drama"], note: "", isFavorite: false, isWatched: true),
            Title(name: "Interstellar", type: .film, genres: ["Sci-Fi", "Drama"], note: "A team of explorers travel through a wormhole in space.", isFavorite: true, isWatched: true),
            Title(name: "Stranger Things", type: .series, genres: ["Sci-Fi", "Horror"], note: "", isFavorite: true, isWatched: false)
        ]
        
        titles.append(contentsOf: sampleTitles)
        
        // Simulate some rolls
        if let inception = titles.first(where: { $0.name == "Inception" }) {
            var updatedTitle = inception
            updatedTitle.rollCount = 7
            updatedTitle.lastRolled = Date()
            updateTitle(updatedTitle)
        }
        
        rollsThisMonth = 34
        userProfile.totalRolls = 42
        userProfile.memberSince = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        saveData()
        checkAchievements()
    }
}

