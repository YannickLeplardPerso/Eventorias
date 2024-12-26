//
//  ErrorAlertModifier.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 16/12/2024.
//

import SwiftUI



struct EventAlertModifier: ViewModifier {
    let error: Binding<EventError?>
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: error.wrappedValue != nil ? 3 : 0)
                .accessibilityHidden(error.wrappedValue != nil)
            
            if let error = error.wrappedValue {
                // pour atténuer la vue en fond
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
                
                VStack(spacing: 12) {
                    Circle()
                        .fill(.evBackground)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "exclamationmark")
                                .foregroundColor(.evMain)
                                .font(.system(size: 20))
                        )
                        .padding(.bottom, 20)
                        .accessibilityHidden(true)
                    
                    Text(error.localizedDescription)
                        .foregroundColor(.evMain)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .padding(.bottom, 20)
                        .accessibilityLabel("Error: \(error.localizedDescription)")
                    
                    Button {
                        self.error.wrappedValue = nil
                    } label: {
                        Text("OK")
                            .foregroundColor(.evMain)
                            .frame(width: 120)
                            .padding(.vertical, 8)
                            .background(.evRed)
                            .cornerRadius(8)
                    }
                    .accessibilityLabel("Dismiss error")
                    .accessibilityHint("Closes the error message")
                }
                .padding(20)
                .background(.background)
                .cornerRadius(12)
                .frame(maxWidth: 250)
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
            }
        }
    }
}

extension View {
    func eventAlert(error: Binding<EventError?>) -> some View {
        modifier(EventAlertModifier(error: error))
    }
}
