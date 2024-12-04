//
//  EventError.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI



enum EventError: LocalizedError {
    case xx
    
    var errorDescription: String? {
        switch self {
        case .xx:
            return "XX"
        }
    }
}
