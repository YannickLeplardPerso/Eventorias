//
//  SortMenuComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 18/12/2024.
//

import SwiftUI



struct SortMenuComponent: View {
    @Binding var selectedSort: SortOption
    @Environment(\.dismiss) var dismiss
    
    var onSortSelected: (SortOption) -> Void
    
    var body: some View {
        List {
            Section("Par Date") {
                Button {
                    onSortSelected(.date(ascending: false))
                    dismiss()
                } label: {
                    HStack {
                        Text("Plus récent → Plus ancien")
                        Spacer()
                        if case .date(let ascending) = selectedSort, !ascending {
                            Image(systemName: "checkmark")
                                .foregroundColor(.evMain)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .accessibilityLabel("Trier du plus récent au plus ancien")
                .accessibilityIdentifier(AccessID.sortRecentToOld)
                
                Button {
                    onSortSelected(.date(ascending: true))
                    dismiss()
                } label: {
                    HStack {
                        Text("Plus ancien → Plus récent")
                        Spacer()
                        if case .date(let ascending) = selectedSort, ascending {
                            Image(systemName: "checkmark")
                                .foregroundColor(.evMain)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .accessibilityLabel("Trier du plus ancien au plus récent")
                .accessibilityIdentifier(AccessID.sortOldToRecent)
            }
            .accessibilityIdentifier(AccessID.sortDateSection)
            
            Section("Par Catégorie") {
                Button {
                    onSortSelected(.category(nil))
                    dismiss()
                } label: {
                    HStack {
                        Text("Toutes les catégories")
                        Spacer()
                        if case .category(nil) = selectedSort {
                            Image(systemName: "checkmark")
                                .foregroundColor(.evMain)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .accessibilityLabel("Afficher toutes les catégories")
                .accessibilityIdentifier("sort-all-categories")
                
                ForEach(EventCategory.allCases, id: \.self) { category in
                    Button {
                        onSortSelected(.category(category))
                        dismiss()
                    } label: {
                        HStack {
                            Text(category.rawValue)
                            Spacer()
                            if case .category(let selectedCategory) = selectedSort, selectedCategory == category {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.evMain)
                                    .accessibilityHidden(true)
                            }
                        }
                    }
                    .accessibilityLabel("Filtrer par catégorie \(category.rawValue)")
                    .accessibilityIdentifier(AccessID.sortCategory(category.rawValue))
                }
            }
            .accessibilityIdentifier(AccessID.sortCategorySection)
        }
        .accessibilityElement(children: .contain)
    }
}

#Preview("Menu de tri") {
    struct PreviewWrapper: View {
        @State private var selectedSort: SortOption = .date(ascending: true)
        
        var body: some View {
            NavigationView {
                SortMenuComponent(
                    selectedSort: $selectedSort,
                    onSortSelected: { newSort in
                        selectedSort = newSort
                    }
                )
                .navigationTitle("Trier")
            }
        }
    }
    
    return PreviewWrapper()
}
