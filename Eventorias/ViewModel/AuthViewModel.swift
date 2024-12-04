//
//  AuthViewModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 25/11/2024.
//

//import Foundation
import SwiftUI
import FirebaseAuth



class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var isLoading = false
    
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                } else {
                    self?.isAuthenticated = true
                    completion()
                }
            }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping () -> Void) {
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                } else {
                    self?.isAuthenticated = true
                    completion()
                }
            }
        }
    }
    
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            isAuthenticated = false
//        } catch {
//            errorMessage = error.localizedDescription
//            showError = true
//        }
//    }
}
