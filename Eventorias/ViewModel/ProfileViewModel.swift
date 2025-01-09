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
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            if let item = selectedItem {
                Task { await updateProfilePicture(item) }
            }
        }
    }
    
    //    @Published var selectedItem: PhotosPickerItem? {
    //        didSet {
    //            Task { await handleSelectedItem() }
    //        }
    //    }
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    private let authService: AuthServiceProtocol
    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
        loadUserProfile()
        Task {
            await reloadUserProfile()
        }
    }
    
    func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? ""
            userName = user.displayName ?? ""
            profileImageUrl = user.photoURL?.absoluteString
        }
    }
    
    @MainActor
    func reloadUserProfile() async {
        guard let user = Auth.auth().currentUser else {
            error = .unauthorizedAccess
            return
        }
        
        do {
            try await user.reload()
            loadUserProfile()
        } catch {
            self.error = .unknownError("reloadUserProfile: \(error.localizedDescription)")
        }
    }
    
    func updateUserProfile() async {
        guard let user = Auth.auth().currentUser else {
            error = .unauthorizedAccess
            return
        }
        
        do {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = userName
            try await changeRequest.commitChanges()
            //            try await user.reload()
            await reloadUserProfile()
        } catch {
            self.error = .unknownError("updateUserProfile: \(error.localizedDescription)")
        }
    }
    @MainActor
    func updateProfilePicture(_ item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                error = .imageProcessingFailed
                return
            }
            
            isLoading = true
            selectedImage = image
            
            guard let userId = Auth.auth().currentUser?.uid,
                  let imageData = image.jpegData(compressionQuality: 0.5) else {
                error = .imageProcessingFailed
                isLoading = false
                return
            }
            
            let storageRef = storage.reference().child("profile_images/\(userId).jpg")
            // S'assurer que l'upload est terminé
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            _ = try await storageRef.putDataAsync(imageData, metadata: metadata)  // Attendre la fin de l'upload
            let url = try await storageRef.downloadURL()
            
            guard let user = Auth.auth().currentUser else {
                error = .unauthorizedAccess
                isLoading = false
                return
            }
            
            // Mettre à jour Auth
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.photoURL = url
            try await changeRequest.commitChanges()
            try await user.reload()
            
            // Mettre à jour Firestore
            try await db.collection("users").document(user.uid).setData([
                "profileImageUrl": url.absoluteString
            ], merge: true)
            
            // Mettre à jour le ViewModel
            profileImageUrl = url.absoluteString
            isLoading = false
        } catch {
            self.error = .profileUpdateFailed
            isLoading = false
        }
    }
}
