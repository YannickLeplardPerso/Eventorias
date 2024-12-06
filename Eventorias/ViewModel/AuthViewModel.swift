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
    
    func signUp(email: String, password: String, name: String, completion: @escaping () -> Void) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
                return
            }
            
            // Mise à jour du nom
            let changeRequest = result?.user.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                    self?.isLoading = false
                    // Important : recharger le profil après la mise à jour
                    if error == nil {
                        result?.user.reload { _ in
                            self?.isAuthenticated = true
                            completion()
                        }
                    }
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
