//
//  FirebaseAuthService.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 30/12/2024.
//

import FirebaseAuth



class FirebaseAuthService: AuthServiceProtocol {
    private let auth = Auth.auth()
    
    var currentUser: UserProtocol? {
        auth.currentUser.map(FirebaseUser.init)
    }
    
    func signIn(email: String, password: String) async throws -> UserProtocol {
        let result = try await auth.signIn(withEmail: email, password: password)
        return FirebaseUser(user: result.user)
    }
    
    func signUp(email: String, password: String, name: String) async throws -> UserProtocol {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = FirebaseUser(user: result.user)
        try await user.updateProfile(displayName: name)
        return user
    }
}

class FirebaseUser: UserProtocol {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var uid: String { user.uid }
    var email: String? { user.email }
    var displayName: String? { user.displayName }
    var photoURL: URL? { user.photoURL }
    
    func updateProfile(displayName: String?) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
        try await user.reload()
    }
}
//extension User: UserProtocol {
//    // pas besoin d'implémenter uid, email, displayName, photoURL
//    // car ils existent déjà dans User
//    
//    func createProfileChangeRequest() -> ProfileChangeRequest {
//        let firebaseRequest = self.createProfileChangeRequest()
//        return FirebaseProfileChangeRequest(request: firebaseRequest)
//    }
//}

//class FirebaseAuthService: AuthServiceProtocol {
//    private let auth = Auth.auth()
//    
//    var currentUser: UserProtocol? {
//        auth.currentUser
//    }
//    
//    func signIn(email: String, password: String) async throws -> UserProtocol {
//        let result = try await auth.signIn(withEmail: email, password: password)
//        return result.user
//    }
//}
//
//class FirebaseUserWrapper: UserProtocol {
//    private let user: User
//    
//    init(user: User) {
//        self.user = user
//    }
//    
//    var uid: String { user.uid }
//    var email: String? { user.email }
//    var displayName: String? { user.displayName }
//    var photoURL: URL? { user.photoURL }
//    
//    func createProfileChangeRequest() -> ProfileChangeRequest {
//        let firebaseRequest = user.createProfileChangeRequest()
//        return FirebaseProfileChangeRequest(request: firebaseRequest)
//    }
//}
//
//class FirebaseProfileChangeRequest: ProfileChangeRequest {
//    private let request: FirebaseAuth.UserProfileChangeRequest
//    
//    init(request: FirebaseAuth.UserProfileChangeRequest) {
//        self.request = request
//    }
//    
//    var displayName: String? {
//        get { request.displayName }
//        set { request.displayName = newValue }
//    }
//    
//    var photoURL: URL? {
//        get { request.photoURL }
//        set { request.photoURL = newValue }
//    }
//    
//    func commitChanges() async throws {
//        try await request.commitChanges()
//    }
//}
