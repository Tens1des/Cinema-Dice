//
//  SettingsView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showResetAlert = false
    @State private var showProfileEdit = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background(dataManager.appTheme).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                                Text("settings".localized())
                                    .font(.dynamicSize(34, weight: .bold, textSize: dataManager.textSize))
                                    .foregroundColor(AppColors.text(dataManager.appTheme))
                                Text("customize_experience".localized())
                                    .font(.dynamicSize(15, textSize: dataManager.textSize))
                                    .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Profile Section
                        Button(action: {
                            showProfileEdit = true
                        }) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.primary)
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: dataManager.userProfile.avatar)
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dataManager.userProfile.name)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(AppColors.text(dataManager.appTheme))
                                    Text("Member since \(formatMemberDate())")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                            }
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(16)
                        }
                        
                        // Appearance Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("appearance".localized())
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                            
                            // Theme
                            HStack {
                                Image(systemName: dataManager.appTheme == .dark ? "moon.fill" : "sun.max.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.text(dataManager.appTheme))
                                    .frame(width: 32)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("theme".localized())
                                        .font(.system(size: 17))
                                        .foregroundColor(AppColors.text(dataManager.appTheme))
                                    Text(dataManager.appTheme == .dark ? "dark_mode_enabled".localized() : "light_mode_enabled".localized())
                                        .font(.system(size: 13))
                                        .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "sun.max.fill")
                                        .foregroundColor(dataManager.appTheme == .light ? AppColors.primary : AppColors.textSecondary)
                                    
                                    Toggle("", isOn: Binding(
                                        get: { dataManager.appTheme == .dark },
                                        set: { isDark in
                                            dataManager.appTheme = isDark ? .dark : .light
                                            dataManager.saveData()
                                        }
                                    ))
                                    .labelsHidden()
                                    .tint(AppColors.primary)
                                    
                                    Image(systemName: "moon.fill")
                                        .foregroundColor(dataManager.appTheme == .dark ? AppColors.primary : AppColors.textSecondary)
                                }
                            }
                            .padding(16)
                            .background(AppColors.cardBackground(dataManager.appTheme))
                            .cornerRadius(12)
                            
                            // Text Size
                            HStack {
                                Image(systemName: "textformat.size")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.text(dataManager.appTheme))
                                    .frame(width: 32)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("text_size".localized())
                                        .font(.system(size: 17))
                                        .foregroundColor(AppColors.text(dataManager.appTheme))
                                    Text("adjust_font_size".localized())
                                        .font(.system(size: 13))
                                        .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                }
                                
                                Spacer()
                                
                                Menu {
                                    ForEach(TextSize.allCases, id: \.self) { size in
                                        Button(action: {
                                            dataManager.textSize = size
                                            dataManager.saveData()
                                        }) {
                                            HStack {
                                                Text(size.rawValue)
                                                if dataManager.textSize == size {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(dataManager.textSize.localizedName)
                                            .font(.system(size: 17))
                                            .foregroundColor(AppColors.text(dataManager.appTheme))
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(AppColors.cardBackground(dataManager.appTheme).opacity(0.5))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(16)
                            .background(AppColors.cardBackground(dataManager.appTheme))
                            .cornerRadius(12)
                        }
                        
                        // General Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("general".localized())
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                            
                            // Language
                            Menu {
                                ForEach(AppLanguage.allCases, id: \.self) { language in
                                    Button(action: {
                                        dataManager.appLanguage = language
                                        dataManager.saveData()
                                    }) {
                                        HStack {
                                            Text(language.flag)
                                            Text(language.displayName)
                                            if dataManager.appLanguage == language {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "globe")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.text(dataManager.appTheme))
                                        .frame(width: 32)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("language".localized())
                                            .font(.system(size: 17))
                                            .foregroundColor(AppColors.text(dataManager.appTheme))
                                        Text(dataManager.appLanguage.displayName)
                                            .font(.system(size: 13))
                                            .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                }
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(12)
                            }
                        }
                        
                        
                        // Data Management Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("data_management".localized())
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                            
                            // Load Sample Data
                            if dataManager.titles.isEmpty {
                                Button(action: {
                                    dataManager.loadSampleData()
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.down")
                                            .font(.system(size: 20))
                                            .foregroundColor(.green)
                                            .frame(width: 32)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Load Sample Data")
                                                .font(.system(size: 17))
                                                .foregroundColor(.green)
                                            Text("Add example movies and series to test the app")
                                                .font(.system(size: 13))
                                                .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(16)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                }
                            }
                            
                            // Clean Corrupted Data
                            Button(action: {
                                dataManager.cleanCorruptedData()
                            }) {
                                HStack {
                                    Image(systemName: "wand.and.rays")
                                        .font(.system(size: 20))
                                        .foregroundColor(.orange)
                                        .frame(width: 32)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Clean Corrupted Data")
                                            .font(.system(size: 17))
                                            .foregroundColor(.orange)
                                        Text("Remove titles with invalid names")
                                            .font(.system(size: 13))
                                            .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(12)
                            }
                            
                            // Reset All Data
                            Button(action: {
                                showResetAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.primary)
                                        .frame(width: 32)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Reset All Data")
                                            .font(.system(size: 17))
                                            .foregroundColor(AppColors.primary)
                                        Text("Delete all titles, stats, and achievements")
                                            .font(.system(size: 13))
                                            .foregroundColor(AppColors.textSecondary(dataManager.appTheme))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 32)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showProfileEdit) {
                ProfileEditView()
            }
            .alert("Reset All Data", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    dataManager.resetAllData()
                }
            } message: {
                Text("Are you sure you want to delete all your data? This action cannot be undone.")
            }
        }
    }
    
    private func formatMemberDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: dataManager.userProfile.memberSince)
    }
}

struct ProfileEditView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var selectedAvatar: String = "person.fill"
    
    let avatarOptions = [
        "person.fill", "person.circle.fill", "person.2.fill", "person.3.fill",
        "star.fill", "heart.fill", "crown.fill", "diamond.fill",
        "flame.fill", "bolt.fill", "leaf.fill", "sun.max.fill"
    ]
    
    init() {
        _name = State(initialValue: DataManager.shared.userProfile.name)
        _selectedAvatar = State(initialValue: DataManager.shared.userProfile.avatar)
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Cancel Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                    Text("cancel".localized())
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                    }
                    Spacer()
                    Text("edit_profile".localized())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: saveProfile) {
                        Text("save".localized())
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 32) {
                    
                    // Avatar Selection
                    VStack(spacing: 16) {
                        Text("choose_avatar".localized())
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(avatarOptions, id: \.self) { avatar in
                                Button(action: {
                                    selectedAvatar = avatar
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedAvatar == avatar ? AppColors.primary : AppColors.cardBackground(dataManager.appTheme))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: avatar)
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("name".localized())
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        
                        TextField("enter_name".localized(), text: $name)
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(16)
                            .background(AppColors.cardBackground(dataManager.appTheme))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func saveProfile() {
        dataManager.userProfile.name = name.isEmpty ? "Movie Lover" : name
        dataManager.userProfile.avatar = selectedAvatar
        dataManager.saveData()
        presentationMode.wrappedValue.dismiss()
    }
}

