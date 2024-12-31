//
//  Auth+protocol.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 30/12/2024.
//

//import FirebaseAuth
//
//
//
//extension Auth: AuthServiceProtocol {
//    var currentUser: UserProtocol? {
//        Auth.auth().currentUser
//    }
//    
//    func signIn(email: String, password: String) async throws -> UserProtocol {
//        let result = try await Auth.auth().signIn(withEmail: email, password: password)
//        return result.user
//    }
//}
//
//extension User {
//    func createProfileChangeRequest() -> ProfileChangeRequest {
//        let firebaseRequest = self.createProfileChangeRequest()
//        return FirebaseProfileChangeRequest(request: firebaseRequest)
//    }
//}
