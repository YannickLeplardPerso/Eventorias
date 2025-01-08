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

//class MockAuthService: AuthServiceProtocol {
//    var shouldSucceed = true
//    
//    func signIn(email: String, password: String) async throws -> User {
//        if shouldSucceed {
//            return MockUser(uid: "testUID", email: email)
//        } else {
//            throw EventError.signInFailed
//        }
//    }
//    
//    func signUp(email: String, password: String, name: String) async throws -> User {
//        if shouldSucceed {
//            return MockUser(uid: "testUID", email: email, displayName: name)
//        } else {
//            throw EventError.signUpFailed
//        }
//    }
//}

//class MockAuthService: AuthServiceProtocol {
//    var shouldSucceed = true
//    var mockUser: UserProtocol?
//    
//    var currentUser: UserProtocol? { mockUser }
//    
//    func signIn(email: String, password: String) async throws -> UserProtocol {
//        if shouldSucceed {
//            let user = MockUser(uid: "testUID", email: email, displayName: "Test User", photoURL: nil)
//            mockUser = user
//            return user
//        }
//        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock authentication failed"])
//    }
//    
//    func signUp(email: String, password: String, name: String) async throws -> UserProtocol {
//        if shouldSucceed {
//            let user = MockUser(uid: "testUID", email: email, displayName: name, photoURL: nil)
//            mockUser = user
//            return user
//        }
//        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock signup failed"])
//    }
//}
