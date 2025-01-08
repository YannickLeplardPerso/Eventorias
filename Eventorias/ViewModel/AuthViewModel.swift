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
    
    private let authService: AuthServiceProtocol
    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
    }
//    private let auth = Auth.auth()
    @MainActor
    func signIn(email: String, password: String) async {
        guard !email.isEmpty else {
            error = .invalidEmail
            return
        }
        guard !password.isEmpty else {
            error = .invalidPassword
            return
        }
        
        isLoading = true
        
        do {
            _ = try await authService.signIn(email: email, password: password)
            isAuthenticated = true
            error = nil
        } catch {
            isAuthenticated = false
            self.error = .unknownError("signIn failed: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func signUp(email: String, password: String, name: String) async {
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
        
        do {
            _ = try await authService.signUp(email: email, password: password, name: name)
            isAuthenticated = true
            error = nil
        } catch {
            isAuthenticated = false
            self.error = .unknownError("signUp failed: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
