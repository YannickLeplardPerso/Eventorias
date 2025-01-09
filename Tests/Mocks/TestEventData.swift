//
//  TestEventData.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 08/01/2025.
//

import Foundation
import SwiftUI
@testable import Eventorias



struct TestEventData {
    struct Locations {
        static let zenithParis = EventLocation(
            address: "Zénith de Paris, 211 Avenue Jean Jaurès, 75019 Paris",
            latitude: 48.8932,
            longitude: 2.3934
        )
        
        static let palaisDesCongresParis = EventLocation(
            address: "Palais des Congrès, 2 Place de la Porte Maillot, 75017 Paris",
            latitude: 48.8785,
            longitude: 2.2833
        )
        
        static let invalidLocation = EventLocation(
            address: "",
            latitude: nil,
            longitude: nil
        )
    }
    
    struct Events {
        static let concertIronMaiden = Event(
            title: "Powerslave tour",
            description: "Concert Iron Maiden",
            date: Date(),
            location: Locations.zenithParis,
            category: .culture,
            creatorId: "1",
            createdAt: Date()
        )
        
        static let xCodeConference = Event(
            title: "Conférence xCode",
            description: "le nouveau framework testing",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .business,
            creatorId: "2",
            createdAt: Date()
        )
        
        static let todayEvent = Event(
            title: "Tournoi tennis",
            description: "Description tournoi tennis",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .sports,
            creatorId: "2",
            createdAt: Date()
        )
        
        static let tomorrowEvent = Event(
            title: "Concert",
            description: "Description Concert",
            date: Date().addingTimeInterval(86400),
            location: Locations.zenithParis,
            category: .culture,
            creatorId: "1",
            createdAt: Date()
        )
        
        static let sportEvent = Event(
            title: "Événement sportif",
            description: "Description sport",
            date: Date(),
            location: Locations.zenithParis,
            category: .sports,
            creatorId: "1",
            createdAt: Date()
        )
        
        static let cultureEvent1 = Event(
            title: "Événement culturel 1",
            description: "Description culture 1",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .culture,
            creatorId: "2",
            createdAt: Date()
        )
        
        static let businessEvent = Event(
            title: "Événement business",
            description: "Description business",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .business,
            creatorId: "2",
            createdAt: Date()
        )
        
        static let cultureEvent2 = Event(
            title: "Événement culturel 2",
            description: "Description culture 2",
            date: Date(),
            location: Locations.palaisDesCongresParis,
            category: .culture,
            creatorId: "1",
            createdAt: Date()
        )
    }
}
