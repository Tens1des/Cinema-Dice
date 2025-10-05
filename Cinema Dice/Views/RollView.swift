//
//  RollView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

enum ContentTypeFilter: String, CaseIterable {
    case films = "Films"
    case series = "Series"
    case mix = "Mix"
}

struct RollView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var selectedContentType: ContentTypeFilter = .mix
    @State private var numberOfResults = 1
    @State private var selectedGenres: Set<String> = []
    @State private var excludeWatched = true
    @State private var showResult = false
    @State private var rolledTitles: [Title] = []
    @State private var isRolling = false
    @State private var diceRotation: Double = 0
    
    var availableTitles: [Title] {
        dataManager.titles.filter { title in
            let typeMatch: Bool
            switch selectedContentType {
            case .films:
                typeMatch = title.type == .film
            case .series:
                typeMatch = title.type == .series
            case .mix:
                typeMatch = true
            }
            
            let watchedMatch = !excludeWatched || !title.isWatched
            let genreMatch = selectedGenres.isEmpty || !Set(title.genres).isDisjoint(with: selectedGenres)
            
            return typeMatch && watchedMatch && genreMatch
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Roll the Dice")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Text("Configure your random pick")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Content Type
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Content Type")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                ForEach(ContentTypeFilter.allCases, id: \.self) { type in
                                    ContentTypeButton(
                                        title: type.rawValue,
                                        icon: iconForType(type),
                                        isSelected: selectedContentType == type
                                    ) {
                                        selectedContentType = type
                                    }
                                }
                            }
                        }
                        
                        // Number of Results
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Number of Results")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                ForEach([1, 2, 3], id: \.self) { number in
                                    NumberButton(
                                        number: number,
                                        isSelected: numberOfResults == number
                                    ) {
                                        numberOfResults = number
                                    }
                                }
                            }
                        }
                        
                        // Genres & Tags
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Genres & Tags")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            
                            let allGenres = Array(Set(dataManager.titles.flatMap { $0.genres })).sorted()
                            
                            FlowLayout(spacing: 8) {
                                ForEach(allGenres.prefix(7), id: \.self) { genre in
                                    GenreChip(
                                        title: genre,
                                        isSelected: selectedGenres.contains(genre)
                                    ) {
                                        if selectedGenres.contains(genre) {
                                            selectedGenres.remove(genre)
                                        } else {
                                            selectedGenres.insert(genre)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Options
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Options")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Toggle(isOn: $excludeWatched) {
                                Text("Exclude watched titles")
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                            }
                            .tint(AppColors.primary)
                            .padding(16)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                        }
                        
                        // Dice Visualization
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.primary)
                                .frame(width: 140, height: 140)
                            
                            Image(systemName: "dice.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(diceRotation))
                        }
                        .padding(.vertical, 24)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
                
                // Roll Button
                VStack {
                    Spacer()
                    
                    Button(action: rollDice) {
                        HStack {
                            Image(systemName: "arrow.2.circlepath")
                            Text("Roll the Dice")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(availableTitles.isEmpty ? AppColors.textSecondary : AppColors.primary)
                        .cornerRadius(16)
                    }
                    .disabled(availableTitles.isEmpty || isRolling)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showResult) {
                RollResultView(titles: rolledTitles)
            }
        }
    }
    
    private func iconForType(_ type: ContentTypeFilter) -> String {
        switch type {
        case .films: return "film"
        case .series: return "tv"
        case .mix: return "square.grid.2x2"
        }
    }
    
    private func rollDice() {
        guard !availableTitles.isEmpty else { return }
        
        isRolling = true
        
        // Animate dice
        withAnimation(.easeInOut(duration: 0.5).repeatCount(3)) {
            diceRotation += 360
        }
        
        // Perform roll after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let count = min(numberOfResults, availableTitles.count)
            rolledTitles = Array(availableTitles.shuffled().prefix(count))
            
            // Update roll counts
            for title in rolledTitles {
                dataManager.incrementRollCount(for: title.id)
            }
            
            // Record roll
            dataManager.recordRoll()
            dataManager.unlockAchievement(.firstRoll)
            
            if numberOfResults == 3 {
                dataManager.unlockAchievement(.tripleRoll)
            }
            
            isRolling = false
            showResult = true
        }
    }
}

struct ContentTypeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : AppColors.textSecondary)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(isSelected ? AppColors.primary : AppColors.cardBackground)
            .cornerRadius(16)
        }
    }
}

struct NumberButton: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(isSelected ? AppColors.primary : AppColors.cardBackground)
                .cornerRadius(16)
        }
    }
}

