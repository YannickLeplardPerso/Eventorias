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
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    @Published var currentSort: SortOption = .date(ascending: true)
    
    private let db = Firestore.firestore()
    
    init() {
        self.newEvent = Self.createEmptyEvent()
    }
    
    static func createEmptyEvent() -> Event {
        Event(
            title: "",
            description: "",
            date: Date(),
            location: EventLocation(
                address: "",
                latitude: nil,
                longitude: nil
            ),
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
    
//    func geocodeAddress(_ address: String) {
//        print("geocodeAddress : \(address)")
//        guard !address.isEmpty else {
//            self.error = .invalidAddress
//            return
//        }
//        print("geocodeAddress: address not empty")
//        
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address) { placemarks, error in
//            DispatchQueue.main.async {
//                if error != nil {
//                    self.error = .invalidAddress
//                    self.newEvent.location = EventLocation(address: address, latitude: nil, longitude: nil)
//                    return
//                }
//                
//                if let coordinates = placemarks?.first?.location?.coordinate {
//                    self.newEvent.location = EventLocation(
//                        address: address,
//                        latitude: coordinates.latitude,
//                        longitude: coordinates.longitude
//                    )
//                    self.cameraPosition = .region(MKCoordinateRegion(
//                        center: coordinates,
//                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                    ))
//                } else {
//                    self.error = .invalidAddress
//                    self.newEvent.location = EventLocation(address: address, latitude: nil, longitude: nil)
//                }
//            }
//        }
//    }
    func geocodeAddress(_ address: String) async {
        guard !address.isEmpty else {
            self.error = .invalidAddress
            return
        }
        
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            
            guard let coordinates = placemarks.first?.location?.coordinate else {
                self.error = .invalidAddress
                self.newEvent.location = EventLocation(address: address, latitude: nil, longitude: nil)
                return
            }
            
            // Mise à jour du modèle
            self.newEvent.location = EventLocation(
                address: address,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )
        } catch {
            self.error = .invalidAddress
            self.newEvent.location = EventLocation(address: address, latitude: nil, longitude: nil)
        }
    }
    
    func updateCameraPosition(for event: Event) -> MapCameraPosition {
        guard let latitude = event.location.latitude,
              let longitude = event.location.longitude else {
            // Position par défaut si pas de coordonnées
            return .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        }
        
        return .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var isFormValid: Bool {
        !newEvent.title.isEmpty &&
        newEvent.location.latitude != nil &&
        newEvent.location.longitude != nil
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
        var filtered = events
        
        // Appliquer le filtre de recherche
        if !searchText.isEmpty {
            filtered = filtered.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Appliquer le filtre de catégorie et le tri
        switch currentSort {
        case .date(let ascending):
            filtered.sort { event1, event2 in
                ascending ? event1.date < event2.date : event1.date > event2.date
            }
        case .category(let selectedCategory):
            if let category = selectedCategory {
                filtered = filtered.filter { $0.category == category }
            }
            filtered.sort { $0.category.rawValue < $1.category.rawValue }
        }
        
        return filtered
    }
    
    func applySort(_ option: SortOption) {
        currentSort = option
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
        print("ADD EVENT WITHOUT IMAGE")
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
        Task { @MainActor in
            // Géocodage asynchrone
            await geocodeAddress(newEvent.location.address)
            
            print("--- title : \(newEvent.title), location latitude: \(String(describing: newEvent.location.latitude)), location longitude : \(String(describing: newEvent.location.longitude))")
            
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
    }
    
//    func addEventWithImage(completion: @escaping () -> Void) {
//        // temp
//        geocodeAddress(newEvent.location.address)
//        
//        print("--- title : \(newEvent.title), location latitude: \(String(describing: newEvent.location.latitude)), location longitude : \(String(describing: newEvent.location.longitude))")
//        guard isFormValid else {
//            error = .invalidEventData
//            return
//        }
//        
//        isLoading = true
//        
//        if let image = selectedImage {
//            uploadImage(image) { [weak self] imageUrl in
//                guard let self = self else { return }
//                
//                if let imageUrl = imageUrl {
//                    if let currentUser = Auth.auth().currentUser {
//                        self.newEvent.creatorId = currentUser.uid
//                        self.newEvent.creatorImageUrl = currentUser.photoURL?.absoluteString
//                        self.newEvent.createdAt = Date()
//                        self.newEvent.imageUrl = imageUrl
//                    }
//                    
//                    do {
//                        try self.db.collection("events").addDocument(from: self.newEvent)
//                        self.resetNewEvent()
//                        DispatchQueue.main.async {
//                            self.isLoading = false
//                            completion()
//                        }
//                    } catch {
//                        DispatchQueue.main.async {
//                            self.error = .eventCreationFailed
//                            self.isLoading = false
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.error = .imageUploadFailed
//                        self.isLoading = false
//                    }
//                }
//            }
//        } else {
//            addEvent {
//                self.isLoading = false
//                completion()
//            }
//        }
//    }
    
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
}
