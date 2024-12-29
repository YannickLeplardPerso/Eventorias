//
//  EventAccessibilityIdentifiers.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 28/12/2024.
//

enum AccessID {
    static let loading = "loading-indicator"
    static let profileImage = "profile-image-button"
    static let profileUsername = "profile-username-textfield"
    static let profileEmail = "profile-email-textfield"
    static let profileNotifications = "profile-notifications-toggle"
    static let eventAdd = "event-add-button"
    static let eventList = "event-list"
    static let eventSearch = "event-search-bar"
    static let eventSort = "events-sort-button"
    
    static func eventCard(_ id: String) -> String {
        "event-card-\(id)"
    }
    static func customTextField(_ title: String) -> String {
        "\(title.lowercased())-field"
    }
        
    static let sortDateSection = "sort-date-section"
    static let sortCategorySection = "sort-category-section"
    static let sortRecentToOld = "sort-recent-to-old"
    static let sortOldToRecent = "sort-old-to-recent"
    
    static func sortCategory(_ category: String) -> String {
        "sort-category-\(category.lowercased())"
    }
}
