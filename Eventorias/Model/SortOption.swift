//
//  SortOption.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 26/12/2024.
//

import Foundation



enum SortOption {
    case date(ascending: Bool)
    case category(EventCategory?)  // nil pour toutes les catégories
}
