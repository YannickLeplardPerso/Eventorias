//
//  EventModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import Foundation
import FirebaseFirestore



enum EventCategory: String, Codable, CaseIterable {
    case music = "Music"
    case culture = "Culture"
    case sports = "Sport"
    case business = "Business"
    case other = "Other"
}

enum SortOption {
    case date
    case category
}

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var date: Date
    var location: String
    var category: EventCategory
    var creatorId: String
    var creatorImageUrl: String?
    var createdAt: Date
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case date
        case location
        case category
        case creatorId
        case creatorImageUrl
        case createdAt
        case imageUrl
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
//        formatter.locale = Locale(identifier: "fr_FR")
        formatter.locale = Locale(identifier: "en")
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
//        formatter.locale = Locale(identifier: "fr_FR")
        formatter.locale = Locale(identifier: "en")
        return formatter.string(from: date)
    }
}

