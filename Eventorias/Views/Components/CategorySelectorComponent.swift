//
//  CategorySelectorComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 05/12/2024.
//

import SwiftUI



struct CategorySelectorComponent: View {
    @Binding var selectedCategory: EventCategory
    let title: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2)  {
                    ForEach(EventCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .font(.system(size: 14))
                                .foregroundColor(.evGray)
                                .lineLimit(1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(selectedCategory == category ? .evRed : .evBackground)
                                )
                        }
                        .accessibilityIdentifier(AccessID.eventAddCategory(category.rawValue.lowercased()))
                        .accessibilityLabel("Category: \(category.rawValue)")
                        .accessibilityAddTraits(selectedCategory == category ? .isSelected : [])
                        .accessibilityHint("Double tap to select this category")
                        .frame(maxWidth: .infinity)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 12)
                .padding(.top, 24)
                .padding(.bottom, 8)
            }
            .background(
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.evGraybis)
                    .padding(.leading, 12)
                    .padding(.top, 8)
                    .accessibilityHidden(true),
                alignment: .topLeading
            )
        }
        .background(.evBackground)
        .cornerRadius(6)
        .accessibilityElement(children: .contain)
    }
}



struct CategorySelectorComponent_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectorComponent(
            selectedCategory: .constant(.sports),
            title: "Category"
        )
        .padding()
    }
}
