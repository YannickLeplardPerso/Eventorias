//
//  TestEvent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 06/01/2025.
//

import Foundation
@testable import Eventorias



struct TestEvent {
    let title: String
    let description: String
    let address: String
    let category: EventCategory
}

extension TestEvent {
//    static let standard = TestEvent(
//        title: "Titre Par défaut",
//        description: "Description de test par défaut",
//        address: "2 Cr de l'île Louviers, 75004 Paris",
//        category: .other
//    )
    
    static func random() -> TestEvent {
        let randomId = UUID().uuidString.prefix(8)
        return TestEvent(
            title: "UI TEST \(randomId)",
            description: "UI TEST Description de \(randomId)",
            address: "2 Cr de l'île Louviers, 75004 Paris",
            category: EventCategory.allCases.randomElement() ?? .other
        )
    }
}
