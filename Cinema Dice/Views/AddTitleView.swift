//
//  AddTitleView.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import SwiftUI

struct AddTitleView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var titleName = ""
    @State private var selectedType: TitleType = .film
    @State private var selectedGenres: Set<String> = []
    @State private var customGenre = ""
    @State private var note = ""
    
    let predefinedGenres = ["Sci-Fi", "Drama", "Comedy", "Thriller", "Horror", "Romance", "Action", "Mystery", "Adventure"]
    
    var body: some View {
        ZStack {
            AppColors.background(dataManager.appTheme).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Close Button
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Add Title")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Text("Fill in the details")
                                .font(.system(size: 15))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        // Title Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title *")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            TextField("Enter movie or series name", text: $titleName)
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(12)
                        }
                        
                        // Type Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Type")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                TypeButton(
                                    type: .film,
                                    icon: "film",
                                    isSelected: selectedType == .film
                                ) {
                                    selectedType = .film
                                }
                                
                                TypeButton(
                                    type: .series,
                                    icon: "tv",
                                    isSelected: selectedType == .series
                                ) {
                                    selectedType = .series
                                }
                            }
                        }
                        
                        // Genres
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Genres & Tags")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(predefinedGenres, id: \.self) { genre in
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
                            
                            // Custom Genre
                            HStack(spacing: 8) {
                                TextField("Add custom tag", text: $customGenre)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(AppColors.cardBackground(dataManager.appTheme))
                                    .cornerRadius(8)
                                
                                Button(action: {
                                    if !customGenre.isEmpty {
                                        selectedGenres.insert(customGenre)
                                        customGenre = ""
                                    }
                                }) {
                                    Text("Add")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(AppColors.cardBackground(dataManager.appTheme))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        // Note
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note (optional)")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .topLeading) {
                                if note.isEmpty {
                                    Text("Add a quick note or description...")
                                        .font(.system(size: 17))
                                        .foregroundColor(AppColors.textSecondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $note)
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                                    .frame(height: 100)
                                    .padding(8)
                                    .scrollContentBackground(.hidden)
                            }
                            .background(AppColors.cardBackground(dataManager.appTheme))
                            .cornerRadius(12)
                            
                            HStack {
                                Spacer()
                                Text("\(note.count)/150")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        
                        // Tip
                        HStack(alignment: .top, spacing: 12) {
                            Text("💡")
                                .font(.system(size: 20))
                            Text("Quick tip: Use tags to filter your rolls. The more specific your tags, the better your recommendations!")
                                .font(.system(size: 13))
                                .foregroundColor(AppColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .background(AppColors.cardBackground(dataManager.appTheme))
                        .cornerRadius(12)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                    .padding(.top, 16)
                }
                
                // Bottom Buttons
                VStack(spacing: 12) {
                    Button(action: saveTitle) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Save Title")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(titleName.isEmpty ? AppColors.textSecondary : AppColors.primary)
                        .cornerRadius(16)
                    }
                    .disabled(titleName.isEmpty)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.cardBackground(dataManager.appTheme))
                            .cornerRadius(16)
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.background.opacity(0), AppColors.background]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
    
    private func saveTitle() {
        let newTitle = Title(
            name: titleName,
            type: selectedType,
            genres: Array(selectedGenres),
            note: String(note.prefix(150))
        )
        dataManager.addTitle(newTitle)
        presentationMode.wrappedValue.dismiss()
    }
}

struct TypeButton: View {
    let type: TitleType
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(type.rawValue)
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : AppColors.textSecondary)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(isSelected ? AppColors.primary : AppColors.cardBackground(dataManager.appTheme))
            .cornerRadius(16)
        }
    }
}

struct GenreChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? AppColors.primary : AppColors.cardBackground(dataManager.appTheme))
                .cornerRadius(20)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for size in sizes {
            if lineWidth + size.width > proposal.width ?? 0 {
                totalHeight += lineHeight + spacing
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            totalWidth = max(totalWidth, lineWidth)
        }
        totalHeight += lineHeight
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if lineX + size.width > bounds.maxX && lineX > bounds.minX {
                lineY += lineHeight + spacing
                lineX = bounds.minX
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: lineX, y: lineY), proposal: .unspecified)
            lineX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}

struct EditTitleView: View {
    let title: Title
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var titleName = ""
    @State private var selectedType: TitleType = .film
    @State private var selectedGenres: Set<String> = []
    @State private var note = ""
    
    init(title: Title) {
        self.title = title
        _titleName = State(initialValue: title.name)
        _selectedType = State(initialValue: title.type)
        _selectedGenres = State(initialValue: Set(title.genres))
        _note = State(initialValue: title.note)
    }
    
    var body: some View {
        ZStack {
            AppColors.background(dataManager.appTheme).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Close Button
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Edit Title")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title *")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            TextField("Enter movie or series name", text: $titleName)
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .padding(16)
                                .background(AppColors.cardBackground(dataManager.appTheme))
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note (optional)")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .topLeading) {
                                if note.isEmpty {
                                    Text("Add a quick note or description...")
                                        .font(.system(size: 17))
                                        .foregroundColor(AppColors.textSecondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $note)
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                                    .frame(height: 100)
                                    .padding(8)
                                    .scrollContentBackground(.hidden)
                            }
                            .background(AppColors.cardBackground(dataManager.appTheme))
                            .cornerRadius(12)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                    .padding(.top, 16)
                }
                
                VStack(spacing: 12) {
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.primary)
                            .cornerRadius(16)
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.cardBackground(dataManager.appTheme))
                            .cornerRadius(16)
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.background.opacity(0), AppColors.background]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
    
    private func saveChanges() {
        var updatedTitle = title
        updatedTitle.name = titleName
        updatedTitle.type = selectedType
        updatedTitle.genres = Array(selectedGenres)
        updatedTitle.note = note
        dataManager.updateTitle(updatedTitle)
        presentationMode.wrappedValue.dismiss()
    }
}

