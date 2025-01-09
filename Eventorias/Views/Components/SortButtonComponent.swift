//
//  SortButtonComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI



struct SortButtonComponent: View {
    @State private var showingSortMenu = false
    @Binding var selectedSort: SortOption
    var onSortSelected: (SortOption) -> Void
    
    var sortLabel: String {
        switch selectedSort {
        case .date(let ascending):
            return "Date: " + (ascending ? "↑" : "↓")
        case .category(let category):
            return "Catégorie: " + (category?.rawValue ?? "Toutes")
        }
    }
    
    var body: some View {
        Button {
            showingSortMenu = true
        } label: {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 16))
                    .foregroundColor(.evMain)
                    .accessibilityHidden(true)
                Text(sortLabel)
                    .font(.system(size: 16))
                    .foregroundColor(.evMain)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.evBackground)
            .cornerRadius(20)
        }
        .accessibilityLabel("Sort events")
        .accessibilityValue(sortLabel)
        .accessibilityHint("Opens sorting options")
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $showingSortMenu) {
            SortMenuComponent(selectedSort: $selectedSort, onSortSelected: onSortSelected)
        }
    }
}



#Preview("Sort Button") {
    struct PreviewWrapper: View {
        @State private var selectedSort: SortOption = .date(ascending: true)
        
        var body: some View {
            VStack {
                SortButtonComponent(
                    selectedSort: $selectedSort,
                    onSortSelected: { newSort in
                        selectedSort = newSort
                    }
                )
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}
