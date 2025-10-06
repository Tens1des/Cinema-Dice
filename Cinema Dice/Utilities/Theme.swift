//
//  Theme.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

extension Font {
    static func dynamicSize(_ size: CGFloat, weight: Font.Weight = .regular, textSize: TextSize = DataManager.shared.textSize) -> Font {
        return .system(size: size * textSize.scale, weight: weight)
    }
}

struct AppColors {
    static let background = Color(hex: "000000")
    static let backgroundLight = Color(hex: "FFFFFF")
    static let cardBackground = Color(hex: "1C1C1E")
    static let cardBackgroundLight = Color(hex: "F2F2F7")
    static let primary = Color(hex: "FF3B30")
    static let secondary = Color(hex: "8E8E93")
    static let text = Color.white
    static let textLight = Color.black
    static let textSecondary = Color(hex: "8E8E93")
    static let textSecondaryLight = Color(hex: "6D6D70")
    
    // Dynamic colors based on theme
    static func background(_ theme: AppTheme) -> Color {
        return theme == .dark ? background : backgroundLight
    }
    
    static func cardBackground(_ theme: AppTheme) -> Color {
        return theme == .dark ? cardBackground : cardBackgroundLight
    }
    
    static func text(_ theme: AppTheme) -> Color {
        return theme == .dark ? text : textLight
    }
    
    static func textSecondary(_ theme: AppTheme) -> Color {
        return theme == .dark ? textSecondary : textSecondaryLight
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

