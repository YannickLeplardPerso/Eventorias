//
//  SortButtonComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI



struct SortButtonComponent: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 16))
                    .foregroundColor(.evMain)
                Text("Sorting")
                    .font(.system(size: 16))
                    .foregroundColor(.evMain)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.evBackground)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



struct SortButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SortButtonComponent(action: {})
        }
        .padding()
    }
}
