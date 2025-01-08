//
//  Event.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import Foundation
import MapKit

import FirebaseFirestore



struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var date: Date
    var location: EventLocation
    var category: EventCategory
    var creatorId: String
    var creatorImageUrl: String?
    var createdAt: Date
    var imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
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
        let formatter = Self.dateFormatter
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = Self.dateFormatter
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
//        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
}

