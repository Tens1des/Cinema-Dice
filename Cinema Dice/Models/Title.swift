//
//  Title.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import Foundation

enum TitleType: String, Codable, CaseIterable {
    case film = "Film"
    case series = "Series"
}

struct Title: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var type: TitleType
    var genres: [String]
    var note: String
    var isFavorite: Bool
    var isWatched: Bool
    var dateAdded: Date
    var rollCount: Int
    var lastRolled: Date?
    
    init(name: String, type: TitleType, genres: [String] = [], note: String = "", isFavorite: Bool = false, isWatched: Bool = false) {
        self.name = name
        self.type = type
        self.genres = genres
        self.note = note
        self.isFavorite = isFavorite
        self.isWatched = isWatched
        self.dateAdded = Date()
        self.rollCount = 0
        self.lastRolled = nil
    }
}

