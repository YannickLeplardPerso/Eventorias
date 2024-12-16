//
//  EventError.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI
import FirebaseAuth



enum EventError: LocalizedError, Identifiable, Hashable {
    case invalidEmail
    case nameRequired
    case invalidEventData
    case eventCreationFailed
    case fetchEventsFailed
    case imageUploadFailed
    case imageProcessingFailed
    case unauthorizedAccess
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .nameRequired:
            return "Please enter your name"
        case .invalidEventData:
            return "Please check all event details are correct"
        case .eventCreationFailed:
            return "Failed to create event. Please try again"
        case .fetchEventsFailed:
            return "Unable to load events. Please check your connection"
        case .imageUploadFailed:
            return "Failed to upload image. Please try again"
        case .imageProcessingFailed:
            return "Failed to process image"
        case .unauthorizedAccess:
            return "Please sign in to continue"
        case .unknownError(let message):
            return message
        }
    }
    
    // Identifiable pour les Alert(item...
    var id: Int { hashValue }
}
