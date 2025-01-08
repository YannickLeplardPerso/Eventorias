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
    case invalidPassword
    case nameRequired
    case invalidEventData
    case titleRequired
    case addressRequired
    case invalidAddress
    case eventCreationFailed
    case fetchEventsFailed
    case imageUploadFailed
    case imageProcessingFailed
    case unauthorizedAccess
    case unknownError(String)
    // pour mock (pour le moment)
    case signInFailed
    case signUpFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Please enter a valid password"
        case .nameRequired:
            return "Please enter your name"
        case .invalidEventData:
            return "Please check all event details are correct"
        case .titleRequired:
            return "Event title is required"
        case .addressRequired:
            return "Event address is required"
        case .invalidAddress:
            return "Address is invalid"
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
        case .signInFailed:
            return "sign in failed"
        case .signUpFailed:
            return "sign up failed"
        }
    }
    
    // Identifiable pour les Alert(item...
    var id: Int { hashValue }
}
