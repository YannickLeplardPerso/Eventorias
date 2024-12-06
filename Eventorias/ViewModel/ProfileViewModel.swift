//
//  ProfileViewModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 06/12/2024.
//

import SwiftUI

import FirebaseAuth
import FirebaseStorage



class ProfileViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var notificationsEnabled: Bool = false
    @Published var selectedImage: UIImage?
    @Published var profileImageUrl: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let storage = Storage.storage()
    
    init() {
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? ""
            userName = user.displayName ?? ""
            print("User loaded: \(self.userName), \(self.userEmail)")
            
            profileImageUrl = user.photoURL?.absoluteString
        }
    }
    
    
    
    
    func updateUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = userName
        
        changeRequest.commitChanges { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid,
              let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        isLoading = true
        let storageRef = storage.reference().child("profile_images/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            storageRef.downloadURL { [weak self] url, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    if let url = url {
                        self?.updateProfileImage(url)
                    }
                }
            }
        }
    }
    
    private func updateProfileImage(_ url: URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        changeRequest?.commitChanges { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.profileImageUrl = url.absoluteString
                }
            }
        }
    }
}
