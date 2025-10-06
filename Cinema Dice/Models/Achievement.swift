//
//  Achievement.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import Foundation

enum AchievementType: String, Codable {
    case firstRoll = "first_roll"
    case movieBuff = "movie_buff"
    case tastemaker = "tastemaker"
    case noteWriter = "note_writer"
    case firstWatched = "first_watched"
    case todayPick = "today_pick"
    case moodPick = "mood_pick"
    case tripleRoll = "triple_roll"
    case reroll = "reroll"
    case statViewer = "stat_viewer"
    case bingeWatcher = "binge_watcher"
    case lucky7 = "lucky_7"
    case genreMaster = "genre_master"
    case curator = "curator"
    case nightOwl = "night_owl"
    case earlyBird = "early_bird"
    case perfectionist = "perfectionist"
    case explorer = "explorer"
    case socialButterfly = "social_butterfly"
}

struct Achievement: Identifiable, Codable {
    let id: AchievementType
    let title: String
    let description: String
    let icon: String
    var isUnlocked: Bool
    var unlockedDate: Date?
    var progress: Int
    var maxProgress: Int
    
    var progressText: String {
        return "\(progress)/\(maxProgress)"
    }
    
    static let allAchievements: [Achievement] = [
        Achievement(id: .firstRoll, title: "First Roll", description: "Made your first dice roll", icon: "🎲", isUnlocked: false, progress: 0, maxProgress: 1),
        Achievement(id: .movieBuff, title: "Movie Buff", description: "Added 20 titles to your library", icon: "🎬", isUnlocked: false, progress: 0, maxProgress: 20),
        Achievement(id: .tastemaker, title: "Tastemaker", description: "Added 5 titles to favorites", icon: "⭐", isUnlocked: false, progress: 0, maxProgress: 5),
        Achievement(id: .noteWriter, title: "Note Writer", description: "Written your first note", icon: "✍️", isUnlocked: false, progress: 0, maxProgress: 1),
        Achievement(id: .firstWatched, title: "Watched!", description: "Marked first title as watched", icon: "✅", isUnlocked: false, progress: 0, maxProgress: 1),
        Achievement(id: .bingeWatcher, title: "Binge Watcher", description: "Watched 50 titles", icon: "📺", isUnlocked: false, progress: 0, maxProgress: 50),
        Achievement(id: .lucky7, title: "Lucky 7", description: "Roll the dice 7 days in a row", icon: "🍀", isUnlocked: false, progress: 0, maxProgress: 7),
        Achievement(id: .genreMaster, title: "Genre Master", description: "Watch titles from 10 different genres", icon: "🎭", isUnlocked: false, progress: 0, maxProgress: 10),
        Achievement(id: .curator, title: "Curator", description: "Have 100 titles in your library", icon: "🏛️", isUnlocked: false, progress: 0, maxProgress: 100),
        Achievement(id: .nightOwl, title: "Night Owl", description: "Roll the dice 10 times after 10 PM", icon: "🦉", isUnlocked: false, progress: 0, maxProgress: 10),
        Achievement(id: .earlyBird, title: "Early Bird", description: "Roll the dice 10 times before 8 AM", icon: "🐦", isUnlocked: false, progress: 0, maxProgress: 10),
        Achievement(id: .perfectionist, title: "Perfectionist", description: "Watch 25 titles in a row without skipping", icon: "🎯", isUnlocked: false, progress: 0, maxProgress: 25),
        Achievement(id: .explorer, title: "Explorer", description: "Try all content types (Films, Series, Mix)", icon: "🗺️", isUnlocked: false, progress: 0, maxProgress: 3),
        Achievement(id: .socialButterfly, title: "Social Butterfly", description: "Add 15 titles with notes", icon: "🦋", isUnlocked: false, progress: 0, maxProgress: 15)
    ]
}

