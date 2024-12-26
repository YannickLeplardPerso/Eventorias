//
//  SearchBarComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI



struct SearchBarComponent: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(.evMain)
                .padding(.leading, 8)
                .accessibilityHidden(true)
            
            TextField("Search", text: $text)
                .font(.system(size: 16))
                .foregroundColor(.evMain)
                .accessibilityLabel("Search events")
                .accessibilityHint("Enter text to filter events")
        }
        .padding(8)
        .background(.evBackground)
        .cornerRadius(20)
    }
}



struct SearchBarComponent_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarComponent(text: .constant(""))
            .padding()
    }
}
