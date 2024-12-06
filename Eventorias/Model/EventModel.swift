//
//  EventModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import Foundation



import FirebaseFirestore
//import FirebaseFirestoreSwift

enum EventCategory: String, Codable, CaseIterable {
    case music = "Music"
    case culture = "Culture"
    case sports = "Sport"
    case business = "Business"
    case other = "Other"
}

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var date: Date
    var location: String
    var category: EventCategory
    var creatorId: String
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case date
        case location
        case category
        case creatorId
        case createdAt
    }
}

