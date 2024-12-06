//
//  EventViewModel.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore



class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var newEvent = Event(
        title: "",
        description: "",
        date: Date(),
        location: "",
        category: .other,
        creatorId: "",
        createdAt: Date()
    )
    @Published var errorMessage = ""
    @Published var showError = false
    
    private let db = Firestore.firestore()
    
    var isFormValid: Bool {
        !newEvent.title.isEmpty && !newEvent.location.isEmpty
    }
    
    func fetchEvents() {
        db.collection("events")
            .order(by: "date")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    self?.errorMessage = error?.localizedDescription ?? "Unknown error"
                    self?.showError = true
                    return
                }
                
                self?.events = documents.compactMap { document -> Event? in
                    try? document.data(as: Event.self)
                }
            }
    }
    
    func addEvent(completion: @escaping () -> Void) {
        guard isFormValid else { return }
        
        newEvent.creatorId = Auth.auth().currentUser?.uid ?? ""
        newEvent.createdAt = Date()
        
        do {
            try db.collection("events").addDocument(from: newEvent)
            // Réinitialiser newEvent pour le prochain événement
            newEvent = Event(title: "", description: "", date: Date(), location: "", category: .other, creatorId: "", createdAt: Date())
            completion()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
