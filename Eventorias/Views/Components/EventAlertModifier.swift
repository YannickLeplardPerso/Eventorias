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
            
            if let error = error.wrappedValue {
                // pour atténuer la vue en fond
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
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
                    
                    Text(error.localizedDescription)
                        .foregroundColor(.evMain)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .padding(.bottom, 20)
                    
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
                }
                .padding(20)
                .background(.background)
                .cornerRadius(12)
                .frame(maxWidth: 250)
            }
        }
    }
}
//struct EventAlertModifier: ViewModifier {
//    let error: Binding<EventError?>
//    
//    func body(content: Content) -> some View {
//        content.alert(item: error) { error in
//            Alert(
//                title: Text("Error"),
//                message: Text(error.localizedDescription),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//    }
//}

extension View {
    func eventAlert(error: Binding<EventError?>) -> some View {
        modifier(EventAlertModifier(error: error))
    }
}
