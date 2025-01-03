//
//  MockAuthService.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 03/01/2025.
//

import Foundation
@testable import Eventorias



class MockAuthService: AuthServiceProtocol {
    var shouldSucceed = true
    var mockUser: UserProtocol?
    
    var currentUser: UserProtocol? { mockUser }
    
    func signIn(email: String, password: String) async throws -> UserProtocol {
        if shouldSucceed {
            let user = MockUser(uid: "testUID", email: email, displayName: "Test User", photoURL: nil)
            mockUser = user
            return user
        }
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock authentication failed"])
    }
    
    func signUp(email: String, password: String, name: String) async throws -> UserProtocol {
        if shouldSucceed {
            let user = MockUser(uid: "testUID", email: email, displayName: name, photoURL: nil)
            mockUser = user
            return user
        }
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock signup failed"])
    }
}
