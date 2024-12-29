//
//  ProfileViewModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 06/12/2024.
//

import SwiftUI
import PhotosUI

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore



class ProfileViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var notificationsEnabled: Bool = false
    @Published var selectedImage: UIImage?
    @Published var profileImageUrl: String?
    @Published var isLoading: Bool = false
    @Published var error: EventError?
    // NEW
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            handleSelectedItem()
        }
    }
    
    private let storage = Storage.storage()
    
    init() {
        loadUserProfile()
    }
    
    func updateUserProfile() {
        guard let user = Auth.auth().currentUser else {
            error = .unauthorizedAccess
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = userName
        
        changeRequest.commitChanges { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.error = .unknownError("updateUserProfile: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func uploadProfileImage(_ image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid,
              let imageData = image.jpegData(compressionQuality: 0.5) else {
            error = .imageProcessingFailed
            return
        }
        
        isLoading = true
        let storageRef = storage.reference().child("profile_images/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = .unknownError("uploadProfileImage: \(error.localizedDescription)")
                }
                return
            }
            
            storageRef.downloadURL { url, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.error = .unknownError("uploadProfileImage failed: \(error.localizedDescription)")
                        return
                    }
                    
                    if let url = url {
                        self.updateProfileImage(url)
                    }
                }
            }
        }
    }
    
    // NEW
    private func handleSelectedItem() {
        guard let item = selectedItem else { return }
        
        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        self.selectedImage = image
                        self.uploadProfileImage(image)
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = .imageProcessingFailed
                }
            }
        }
    }
    
    private func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? ""
            userName = user.displayName ?? ""
            profileImageUrl = user.photoURL?.absoluteString
        }
    }
    
    private func updateProfileImage(_ url: URL) {
        guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else {
            error = .unauthorizedAccess
            return
        }

        changeRequest.photoURL = url
        changeRequest.commitChanges { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = .unknownError("updateProfileImage failed: \(error.localizedDescription)")
                    return
                }
                
                guard let userId = Auth.auth().currentUser?.uid else {
                    self?.error = .unauthorizedAccess
                    return
                }
                
                let db = Firestore.firestore()
                db.collection("users").document(userId).setData([
                    "profileImageUrl": url.absoluteString
                ], merge: true) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self?.error = .unknownError("updateProfileImage failed: \(error.localizedDescription)")
                        } else {
                            self?.profileImageUrl = url.absoluteString
                        }
                    }
                }
            }
        }
    }
}
