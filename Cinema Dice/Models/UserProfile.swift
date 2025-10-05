//
//  UserProfile.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import Foundation

struct UserProfile: Codable {
    var name: String
    var avatar: String
    var memberSince: Date
    var rollStreak: Int
    var lastRollDate: Date?
    var totalRolls: Int
    
    init(name: String = "Movie Lover", avatar: String = "person.fill") {
        self.name = name
        self.avatar = avatar
        self.memberSince = Date()
        self.rollStreak = 0
        self.lastRollDate = nil
        self.totalRolls = 0
    }
}

enum AppTheme: String, Codable, CaseIterable {
    case dark = "Dark"
    case light = "Light"
    
    var displayName: String {
        return self.rawValue
    }
}

enum AppLanguage: String, Codable, CaseIterable {
    case english = "en"
    case russian = "ru"
    
    var displayName: String {
        switch self {
        case .english: return "English (US)"
        case .russian: return "Русский"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .russian: return "🇷🇺"
        }
    }
}

enum TextSize: String, Codable, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    var scale: CGFloat {
        switch self {
        case .small: return 0.9
        case .medium: return 1.0
        case .large: return 1.1
        }
    }
}

