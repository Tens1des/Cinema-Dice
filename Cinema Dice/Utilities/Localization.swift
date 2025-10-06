//
//  Localization.swift
//  Cinema Dice
//
//  Created by Рома Котов on 05.10.2025.
//

import Foundation

struct LocalizedString {
    private static let localizations: [AppLanguage: [String: String]] = [
        .english: [
            // Navigation
            "library": "Library",
            "roll": "Roll", 
            "favorites": "Favorites",
            "stats": "Stats",
            "settings": "Settings",
            
            // Library
            "my_cinema": "My Cinema",
            "unwatched_titles": "unwatched titles",
            "search_titles": "Search titles...",
            "roll_the_dice": "Roll the Dice",
            "add_title": "Add Title",
            "no_titles_yet": "No titles yet",
            "add_first_movie": "Add your first movie or series\nto get started",
            
            // Add/Edit Title
            "fill_details": "Fill in the details",
            "title_required": "Title *",
            "enter_movie_name": "Enter movie or series name",
            "type": "Type",
            "film": "Film",
            "series": "Series",
            "genres_tags": "Genres & Tags",
            "add_custom_tag": "Add custom tag",
            "add": "Add",
            "note_optional": "Note (optional)",
            "add_note": "Add a quick note or description...",
            "quick_tip": "Quick tip: Use tags to filter your rolls. The more specific your tags, the better your recommendations!",
            "save_title": "Save Title",
            "cancel": "Cancel",
            "save_changes": "Save Changes",
            "edit_title": "Edit Title",
            
            // Roll
            "configure_random_pick": "Configure your random pick",
            "content_type": "Content Type",
            "films": "Films",
            "mix": "Mix",
            "number_of_results": "Number of Results",
            "options": "Options",
            "exclude_watched": "Exclude watched titles",
            "your_pick_is": "Your pick is...",
            "roll_again": "Roll Again",
            "back_to_library": "Back to Library",
            
            // Favorites
            "unwatched_favorites": "unwatched favorites",
            "search_favorites": "Search favorites...",
            "no_favorites_yet": "No favorites yet",
            "add_favorites_here": "Add titles to favorites to see them here",
            "roll_from_favorites": "Roll from Favorites",
            
            // Stats
            "your_cinema_journey": "Your cinema journey",
            "total_titles": "Total Titles",
            "watched": "Watched",
            "favorites_count": "Favorites",
            "rolls_this_month": "Rolls This Month",
            "most_picked": "Most Picked",
            "picked_times": "Picked {count} times",
            "achievements": "Achievements",
            
            // Settings
            "customize_experience": "Customize your experience",
            "appearance": "APPEARANCE",
            "theme": "Theme",
            "dark_mode_enabled": "Dark mode is enabled",
            "light_mode_enabled": "Light mode is enabled",
            "text_size": "Text Size",
            "adjust_font_size": "Adjust the font size",
            "general": "GENERAL",
            "language": "Language",
            "data_management": "DATA MANAGEMENT",
            "load_sample_data": "Load Sample Data",
            "add_example_movies": "Add example movies and series to test the app",
            "reset_all_data": "Reset All Data",
            "delete_all_data": "Delete all titles, stats, and achievements",
            "choose_avatar": "Choose Avatar",
            "name": "Name",
            "enter_name": "Enter your name",
            "save": "Save",
            "edit_profile": "Edit Profile",
            "member_since": "Member since {date}",
            
            // Common
            "done": "Done",
            "filter_by_genre": "Filter by Genre",
            "clear_all": "Clear All",
            "small": "Small",
            "medium": "Medium", 
            "large": "Large"
        ],
        
        .russian: [
            // Navigation
            "library": "Библиотека",
            "roll": "Бросок",
            "favorites": "Избранное", 
            "stats": "Статистика",
            "settings": "Настройки",
            
            // Library
            "my_cinema": "Мой кинотеатр",
            "unwatched_titles": "непросмотренных фильмов",
            "search_titles": "Поиск фильмов...",
            "roll_the_dice": "Бросить кубик",
            "add_title": "Добавить фильм",
            "no_titles_yet": "Пока нет фильмов",
            "add_first_movie": "Добавьте свой первый фильм или сериал\nдля начала работы",
            
            // Add/Edit Title
            "fill_details": "Заполните детали",
            "title_required": "Название *",
            "enter_movie_name": "Введите название фильма или сериала",
            "type": "Тип",
            "film": "Фильм",
            "series": "Сериал",
            "genres_tags": "Жанры и теги",
            "add_custom_tag": "Добавить тег",
            "add": "Добавить",
            "note_optional": "Заметка (необязательно)",
            "add_note": "Добавить краткую заметку или описание...",
            "quick_tip": "Совет: Используйте теги для фильтрации бросков. Чем конкретнее теги, тем лучше рекомендации!",
            "save_title": "Сохранить фильм",
            "cancel": "Отмена",
            "save_changes": "Сохранить изменения",
            "edit_title": "Редактировать фильм",
            
            // Roll
            "configure_random_pick": "Настройте случайный выбор",
            "content_type": "Тип контента",
            "films": "Фильмы",
            "mix": "Микс",
            "number_of_results": "Количество результатов",
            "options": "Опции",
            "exclude_watched": "Исключить просмотренные",
            "your_pick_is": "Ваш выбор...",
            "roll_again": "Бросить снова",
            "back_to_library": "Назад в библиотеку",
            
            // Favorites
            "unwatched_favorites": "непросмотренных избранных",
            "search_favorites": "Поиск в избранном...",
            "no_favorites_yet": "Пока нет избранных",
            "add_favorites_here": "Добавьте фильмы в избранное, чтобы видеть их здесь",
            "roll_from_favorites": "Бросить из избранного",
            
            // Stats
            "your_cinema_journey": "Ваше кино-путешествие",
            "total_titles": "Всего фильмов",
            "watched": "Просмотрено",
            "favorites_count": "Избранные",
            "rolls_this_month": "Бросков за месяц",
            "most_picked": "Чаще всего выбирается",
            "picked_times": "Выбирался {count} раз",
            "achievements": "Достижения",
            
            // Settings
            "customize_experience": "Настройте свой опыт",
            "appearance": "ВНЕШНИЙ ВИД",
            "theme": "Тема",
            "dark_mode_enabled": "Темная тема включена",
            "light_mode_enabled": "Светлая тема включена",
            "text_size": "Размер текста",
            "adjust_font_size": "Настройте размер шрифта",
            "general": "ОБЩИЕ",
            "language": "Язык",
            "data_management": "УПРАВЛЕНИЕ ДАННЫМИ",
            "load_sample_data": "Загрузить примеры",
            "add_example_movies": "Добавить примеры фильмов и сериалов для тестирования",
            "reset_all_data": "Сбросить все данные",
            "delete_all_data": "Удалить все фильмы, статистику и достижения",
            "choose_avatar": "Выберите аватар",
            "name": "Имя",
            "enter_name": "Введите ваше имя",
            "save": "Сохранить",
            "edit_profile": "Редактировать профиль",
            "member_since": "Участник с {date}",
            
            // Common
            "done": "Готово",
            "filter_by_genre": "Фильтр по жанрам",
            "clear_all": "Очистить все",
            "small": "Маленький",
            "medium": "Средний",
            "large": "Большой"
        ]
    ]
    
    static func localized(_ key: String, for language: AppLanguage = DataManager.shared.appLanguage, arguments: [String] = []) -> String {
        guard let languageDict = localizations[language],
              let localizedString = languageDict[key] else {
            return key
        }
        
        var result = localizedString
        
        // Replace placeholders with arguments
        for (index, argument) in arguments.enumerated() {
            result = result.replacingOccurrences(of: "{\(index)}", with: argument)
        }
        
        // Replace named placeholders
        for argument in arguments {
            if argument.contains(":") {
                let components = argument.components(separatedBy: ":")
                if components.count == 2 {
                    let placeholder = "{\(components[0])}"
                    let value = components[1]
                    result = result.replacingOccurrences(of: placeholder, with: value)
                }
            }
        }
        
        return result
    }
}

// Convenience extension
extension String {
    func localized(for language: AppLanguage = DataManager.shared.appLanguage, arguments: [String] = []) -> String {
        return LocalizedString.localized(self, for: language, arguments: arguments)
    }
}
