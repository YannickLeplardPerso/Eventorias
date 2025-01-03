//
//  MockUser.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 03/01/2025.
//

import Foundation
@testable import Eventorias



struct MockUser: UserProtocol {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    
    func updateProfile(displayName: String?) async throws {
        // Ne fait rien pour le moment
    }
}
