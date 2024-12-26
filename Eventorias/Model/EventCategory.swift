//
//  EventCategory.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 26/12/2024.
//

import Foundation



enum EventCategory: String, Codable, CaseIterable {
    case music = "Music"
    case culture = "Culture"
    case sports = "Sport"
    case business = "Business"
    case other = "Other"
}
