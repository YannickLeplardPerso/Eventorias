//
//  EventCardComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI

// temp
struct EventCardComponent: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.evGray)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.evGray)
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .foregroundColor(.evGray)
                
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.evGray)
                Text(event.location)
                    .foregroundColor(.evGray)
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
    }
}



//#Preview {
//    EventCardComponent()
//}
