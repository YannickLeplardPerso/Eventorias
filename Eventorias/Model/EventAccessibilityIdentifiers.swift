//
//  EventAccessibilityIdentifiers.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 28/12/2024.
//

enum AccessID {
    static let signSheet = "sign-sheet-button"
    static let signToggle = "sign-toggle-button"
    static let signName = "sign-name-textfield"
    static let signEmail = "sign-email-textfield"
    static let signPassword = "sign-password-textfield"
    static let signSubmit = "sign-submit-button"
    static let loading = "loading-indicator"
    static let profileImage = "profile-image-button"
    static let profileUsername = "profile-username-textfield"
    static let profileEmail = "profile-email-textfield"
    static let profileNotifications = "profile-notifications-toggle"
    static let eventView = "event-view"
    static let eventAdd = "event-add-button"
    static let eventAddTitle = "event-add-title-textfield"
    static let eventAddDescription = "event-add-description-textfield"
    static let eventAddAddress = "event-add-address-textfield"
    
    static func eventAddCategory(_ category: String) -> String {
        "event-add-category-\(category.lowercased())"
    }
    
    static let eventList = "event-list"
    static let eventSearch = "event-search-bar"
    static let eventSort = "event-sort-button"
    static let detailView = "detail-view"
    static let eventCreate = "event-create-button"
    
    static func eventCard(_ id: String) -> String {
        "event-card-\(id)"
    }
        
    static let sortDateSection = "sort-date-section"
    static let sortCategorySection = "sort-category-section"
    static let sortRecentToOld = "sort-recent-to-old"
    static let sortOldToRecent = "sort-old-to-recent"
}
