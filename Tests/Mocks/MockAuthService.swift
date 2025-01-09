//
//  MockAuthService.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 03/01/2025.
//

import Foundation
@testable import Eventorias
import FirebaseAuth



class MockAuthService: AuthServiceProtocol {
    var shouldSucceed = true
    var currentUser: User?
    
    func signIn(email: String, password: String) async throws {
        if !shouldSucceed {
            throw EventError.signInFailed
        }
    }
    
    func signUp(email: String, password: String, name: String) async throws {
        if !shouldSucceed {
            throw EventError.signUpFailed
        }
    }
}
