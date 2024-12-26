//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 25/11/2024.
//

import SwiftUI
import FirebaseAuth



class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var error: EventError?
    @Published var isLoading = false
    
//    private let auth: Auth
//    init(auth: Auth = Auth.auth()) {
//        self.auth = auth
//    }
    private let auth = Auth.auth()
    
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        guard !email.isEmpty else {
            error = .invalidEmail
            return
        }
        guard !password.isEmpty else {
            error = .invalidPassword
            return
        }
        
        isLoading = true
        
        auth.signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.error = .unknownError("signIn failed : \(error.localizedDescription)")
                } else {
                    self.isAuthenticated = true
                    completion()
                }
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, completion: @escaping () -> Void) {
        guard !name.isEmpty else {
            error = .nameRequired
            return
        }
        guard !email.isEmpty else {
            error = .invalidEmail
            return
        }
        guard !password.isEmpty else {
            error = .invalidPassword
            return
        }
        
        isLoading = true
        auth.createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.isLoading = false
                    self.error = .unknownError("signUp failed : \(error.localizedDescription)")
                    return
                }
                
                let changeRequest = result?.user.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    if let error = error {
                        self.error = .unknownError("signUp failed : \(error.localizedDescription)")
                        self.isLoading = false
                    } else {
                        result?.user.reload { _ in
                            self.isAuthenticated = true
                            self.isLoading = false
                            completion()
                        }
                    }
                }
            }
        }
    }
}
