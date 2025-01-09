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

    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                await handleSelectedItem()
            }
        }
    }
    
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
            // pour test UI afin d'avoir un nouvel évènment visible sans scroller...
//            date: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 23))!
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
    
    @MainActor
    func resetNewEvent() {
        newEvent = Self.createEmptyEvent()
        selectedImage = nil
        selectedItem = nil
    }
    
    func geocodeAddress(_ address: String) async {
        await MainActor.run {
            guard !address.isEmpty else {
                self.error = .invalidAddress
                return
            }
        }
        
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            
            await MainActor.run {
                guard let coordinates = placemarks.first?.location?.coordinate else {
                    self.error = .invalidAddress
                    self.newEvent.location = EventLocation(address: address, latitude: nil, longitude: nil)
                    return
                }
                
                self.newEvent.location = EventLocation(
                    address: address,
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude
                )
            }
        } catch {
            await MainActor.run {
                self.error = .invalidAddress
                self.newEvent.location = EventLocation(address: address, latitude: nil, longitude: nil)
            }
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
    
    @MainActor
    func fetchEvents() {
        db.collection("events")
            .order(by: "date")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.error = .unknownError("fetchEvents: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    self.error = .fetchEventsFailed
                    return
                }
                
                // D'abord décoder les événements
                let decodedEvents = snapshot.documents.compactMap { document in
                    do {
                        let event = try document.data(as: Event.self)
                        return event
                    } catch {
                        self.error = .unknownError("Unable to load some events: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                if decodedEvents.isEmpty && !snapshot.documents.isEmpty {
                    self.error = .fetchEventsFailed
                }
                
                self.events = decodedEvents
                
                // Puis charger les infos des créateurs
                Task {
                    for event in decodedEvents {
                        if let creatorId = event.creatorId.isEmpty ? nil : event.creatorId {
                            do {
                                let userDoc = try await self.db.collection("users")
                                    .document(creatorId)
                                    .getDocument()
                                
                                if let profileImageUrl = userDoc.data()?["profileImageUrl"] as? String,
                                   let index = self.events.firstIndex(where: { $0.id == event.id }) {
                                    self.events[index].creatorImageUrl = profileImageUrl
                                }
                            } catch {
                                self.error = .unknownError("Error loading creator info: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
    }
    
    var filteredEvents: [Event] {
        var filtered = events
        
        if !searchText.isEmpty {
            filtered = filtered.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
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
    
    @MainActor
    private func addEventAsync() async throws {
        guard isFormValid else {
            throw EventError.invalidEventData
        }

        newEvent.creatorId = Auth.auth().currentUser?.uid ?? ""
        newEvent.createdAt = Date()
        
        try db.collection("events").addDocument(from: newEvent)
        resetNewEvent()
    }
    
    func addEventWithImage() async throws {
        await MainActor.run {
            guard isFormValid else {
                error = .invalidEventData
                return
            }
            isLoading = true
        }
        
        do {
            if let image = selectedImage {
                if let imageUrl = try await uploadImageAsync(image) {
                    if let currentUser = Auth.auth().currentUser {
                        await MainActor.run {
                            newEvent.creatorId = currentUser.uid
                            newEvent.creatorImageUrl = currentUser.photoURL?.absoluteString
                            newEvent.createdAt = Date()
                            newEvent.imageUrl = imageUrl
                        }
                    }
                    
                    try db.collection("events").addDocument(from: newEvent)
                    await MainActor.run {
                        resetNewEvent()
                        isLoading = false
                    }
                } else {
                    await MainActor.run {
                        error = .imageUploadFailed
                        isLoading = false
                    }
                }
            } else {
                try await addEventAsync()
                await MainActor.run {
                    isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.error = .eventCreationFailed
                isLoading = false
            }
        }
    }

    private func uploadImageAsync(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw EventError.imageProcessingFailed
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("events/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
        let url = try await imageRef.downloadURL()
        return url.absoluteString
    }
    
    @MainActor
    func handleSelectedItem() async {
        guard let item = selectedItem else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
            } else {
                error = .imageProcessingFailed
            }
        } catch {
            self.error = .unknownError("handleSelectedItem failed : \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadCreatorInfo(for eventId: String) async {
        do {
            let document = try await db.collection("users").document(eventId).getDocument()
            
            if document.exists {
                creatorPhotoURL = document.data()?["profileImageUrl"] as? String
            }
        } catch {
            self.error = .unknownError(error.localizedDescription)
        }
    }
}
