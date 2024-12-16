//
//  EventViewModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI
import PhotosUI
import MapKit

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage



class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var newEvent: Event
    @Published var error: EventError?
    @Published var isLoading = false
    @Published var searchText = ""
    
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    
    @Published var creatorPhotoURL: String?
    @Published var eventLocation: CLLocationCoordinate2D?
    @Published var cameraPosition: MapCameraPosition = .automatic
    
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
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.error = .unknownError("fetchEvents: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        self.error = .fetchEventsFailed
                        return
                    }
                    
                    let decodedEvents = snapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: Event.self)
                        } catch {
                            self.error = .unknownError("Unable to load some events: \(error.localizedDescription)")
                            return nil
                        }
                    }
                    
                    // Si on n'a décodé aucun événement alors qu'il y en avait
                    if decodedEvents.isEmpty && !snapshot.documents.isEmpty {
                        self.error = .fetchEventsFailed
                    }
                    
                    self.events = decodedEvents
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
        guard isFormValid else {
            error = .invalidEventData
            return
        }
        
        newEvent.creatorId = Auth.auth().currentUser?.uid ?? ""
        newEvent.createdAt = Date()
        
        do {
            try db.collection("events").addDocument(from: newEvent)
            resetNewEvent()
            completion()
        } catch {
            self.error = .eventCreationFailed
        }
    }
    
    func addEventWithImage(completion: @escaping () -> Void) {
        guard isFormValid else {
            error = .invalidEventData
            return
        }
        
        isLoading = true
        
        if let image = selectedImage {
            uploadImage(image) { [weak self] imageUrl in
                guard let self = self else { return }
                
                if let imageUrl = imageUrl {
                    if let currentUser = Auth.auth().currentUser {
                        self.newEvent.creatorId = currentUser.uid
                        self.newEvent.creatorImageUrl = currentUser.photoURL?.absoluteString
                        self.newEvent.createdAt = Date()
                        self.newEvent.imageUrl = imageUrl
                    }
                    
                    do {
                        try self.db.collection("events").addDocument(from: self.newEvent)
                        self.resetNewEvent()
                        DispatchQueue.main.async {
                            self.isLoading = false
                            completion()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.error = .eventCreationFailed
                            self.isLoading = false
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.error = .imageUploadFailed
                        self.isLoading = false
                    }
                }
            }
        } else {
            addEvent {
                self.isLoading = false
                completion()
            }
        }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            DispatchQueue.main.async {
                self.error = .imageProcessingFailed
            }
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("events/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.error = .imageUploadFailed
                }
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.error = .imageUploadFailed
                    }
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
                    } else {
                        self.error = .imageProcessingFailed
                    }
                case .failure(let error):
                    self.error = .unknownError("handleSelectedItem failed : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func loadCreatorInfo(for eventId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(eventId).getDocument { document, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = .unknownError(error.localizedDescription)
                    return
                }
                
                if let document = document, document.exists {
                    self.creatorPhotoURL = document.data()?["profileImageUrl"] as? String
                }
            }
        }
    }
    
    func geocodeLocation(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = .unknownError("Unable to locate address: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first, let location = placemark.location?.coordinate {
                    self.eventLocation = location
                    self.cameraPosition = .region(MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
            }
        }
    }
}
