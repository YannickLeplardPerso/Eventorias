//
//  FirebaseAuthService.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 30/12/2024.
//

import FirebaseAuth



class FirebaseAuthService: AuthServiceProtocol {
    private let auth = Auth.auth()
    
    func signIn(email: String, password: String) async throws {
        // On ignore le User retourné
        _ = try await auth.signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, password: String, name: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        try await result.user.reload()
    }
}
