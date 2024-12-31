//
//  MockEventAuth.swift
//  Tests
//
//  Created by Yannick LEPLARD on 24/12/2024.
//

//import Foundation
//
//
//
//class MockAuthService: AuthServiceProtocol {
//    var currentUser: UserProtocol?
//    
//    func signIn(email: String, password: String) async throws -> UserProtocol {
//        if email == "test@example.com" && password == "password123" {
//            let user = MockUser(uid: "testUID", email: email, displayName: "Test User")
//            currentUser = user
//            return user
//        } else {
//            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
//        }
//    }
//}
//
//class MockUser: UserProtocol {
//    let uid: String
//    let email: String?
//    let displayName: String?
//    let photoURL: URL?
//    
//    init(uid: String, email: String?, displayName: String?, photoURL: URL? = nil) {
//        self.uid = uid
//        self.email = email
//        self.displayName = displayName
//        self.photoURL = photoURL
//    }
//    
//    func createProfileChangeRequest() -> ProfileChangeRequest {
//        return MockProfileChangeRequest()
//    }
//}
//
//class MockProfileChangeRequest: ProfileChangeRequest {
//    var displayName: String?
//    var photoURL: URL?
//    
//    func commitChanges() async throws {
//        // Simulation d'une mise à jour réussie
//        // On pourrait ajouter une logique pour simuler des erreurs si nécessaire
//    }
//}
