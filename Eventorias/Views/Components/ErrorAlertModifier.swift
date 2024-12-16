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
        content.alert(item: error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

extension View {
    func eventAlert(error: Binding<EventError?>) -> some View {
        modifier(EventAlertModifier(error: error))
    }
}
