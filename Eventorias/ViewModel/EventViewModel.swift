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
    @Published var errorMessage = ""
    @Published var showError = false
    private let db = Firestore.firestore()
    
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
    
    func addEvent(title: String, description: String, date: Date, location: String, category: EventCategory) {
        let newEvent = Event(
            title: title,
            description: description,
            date: date,
            location: location,
            category: category,
            creatorId: Auth.auth().currentUser?.uid ?? "",
            createdAt: Date()
        )
        
        do {
            try db.collection("events").addDocument(from: newEvent)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
