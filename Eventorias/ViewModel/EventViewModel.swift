//
//  EventViewModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import Foundation
import _PhotosUI_SwiftUI

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage



class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var newEvent: Event
    @Published var errorMessage = ""
    @Published var showError = false

    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var isUploading = false
    
    @Published var searchText = ""

    private let db = Firestore.firestore()

    init() {
        self.newEvent = Self.createEmptyEvent()
    }

    static func createEmptyEvent() -> Event {
        Event(
            title: "",
            description: "",
            date: Date(),
            location: "",
            category: .other,
            creatorId: "",
            createdAt: Date()
        )
    }

    func resetNewEvent() {
        newEvent = Self.createEmptyEvent()
        selectedImage = nil
        selectedItem = nil
    }

    var isFormValid: Bool {
        !newEvent.title.isEmpty && !newEvent.location.isEmpty
    }

    func fetchEvents() {
        db.collection("events")
            .order(by: "date")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    self?.errorMessage =
                        error?.localizedDescription ?? "Unknown error"
                    self?.showError = true
                    return
                }

                self?.events = documents.compactMap { document -> Event? in
                    try? document.data(as: Event.self)
                }
            }
    }
    
    var filteredEvents: [Event] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func sortEvents(by option: SortOption) {
        switch option {
        case .date:
            events.sort { $0.date < $1.date }
        case .category:
            events.sort { $0.category.rawValue < $1.category.rawValue }
        }
    }

    func addEvent(completion: @escaping () -> Void) {
        guard isFormValid else { return }

        newEvent.creatorId = Auth.auth().currentUser?.uid ?? ""
        newEvent.createdAt = Date()

        do {
            try db.collection("events").addDocument(from: newEvent)
            resetNewEvent()
            completion()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func addEventWithImage(completion: @escaping () -> Void) {
        guard isFormValid else { return }
        isUploading = true

        if let image = selectedImage {
            uploadImage(image) { [weak self] imageUrl in
                guard let self = self else { return }

                if let currentUser = Auth.auth().currentUser {
                    newEvent.creatorId = currentUser.uid
                    newEvent.creatorImageUrl = currentUser.photoURL?.absoluteString
                    newEvent.createdAt = Date()
                    newEvent.imageUrl = imageUrl
                }
                
                do {
                    try self.db.collection("events").addDocument(
                        from: self.newEvent)
                    resetNewEvent()
                    DispatchQueue.main.async {
                        self.isUploading = false
                        completion()
                    }
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                    isUploading = false
                }
            }
        } else {
            addEvent {
                self.isUploading = false
                completion()
            }
        }
    }

    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void)
    {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("events/\(UUID().uuidString).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print(
                        "Error getting download URL: \(error.localizedDescription)"
                    )
                    completion(nil)
                    return
                }

                completion(url?.absoluteString)
            }
        }
    }

    func handleSelectedItem() {
        guard let item = selectedItem else { return }

        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        self.selectedImage = uiImage
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
    }
}
