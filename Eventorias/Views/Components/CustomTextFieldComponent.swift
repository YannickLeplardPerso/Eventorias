//
//  CustomTextFieldComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 05/12/2024.
//

import SwiftUI



// Attention : pour les AccessIdentifiers :
// si isMultiline c'est textViews au lieu de textFields
struct CustomTextFieldComponent: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isMultiline: Bool = false
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                if isMultiline {
                    TextEditor(text: $text)
                        .font(.system(size: 16))
                        .foregroundColor(.evGray)
                        .frame(height: 30)
                        .scrollContentBackground(.hidden) // Cache le fond par défaut
                        .padding(.horizontal, 8)
                        .padding(.top, 24) // Espace pour le titre flottant
                        .padding(.bottom, 8)
                        .accessibilityLabel(title)
                        .accessibilityHint("Multi-line text field")
                        .background(
                            // Pour positionner le titre
                            Text(title)
                                .font(.system(size: 12))
                                .foregroundColor(.evGraybis)
                                .padding(.leading, 12)
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityHidden(true), // Car le label est déjà sur le TextEditor
                            alignment: .topLeading
                        )
                } else if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .foregroundColor(.evGray)
                        .padding(.horizontal, 12)
                        .padding(.top, 24)
                        .padding(.bottom, 8)
                        .accessibilityLabel(title)
                        .accessibilityHint("Secure text field for sensitive information")
                        .background(
                            Text(title)
                                .font(.system(size: 12))
                                .foregroundColor(.evGraybis)
                                .padding(.leading, 12)
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityHidden(true),
                            alignment: .topLeading
                        )
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .foregroundColor(.evGray)
                        .padding(.horizontal, 12)
                        .padding(.top, 24) // Espace pour le titre flottant
                        .padding(.bottom, 8)
                        .accessibilityLabel(title)
                        .accessibilityValue(text)
                        .background(
                            // Pour positionner le titre
                            Text(title)
                                .font(.system(size: 12))
                                .foregroundColor(.evGraybis)
                                .padding(.leading, 12)
                                .padding(.top, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityHidden(true),
                            alignment: .topLeading
                        )
                }
            }
            .background(.evBackground)
            .cornerRadius(6)
        }
    }
}


struct CustomTextFieldComponent_Previews: PreviewProvider {
   static var previews: some View {
       VStack(spacing: 20) {
           CustomTextFieldComponent(
               title: "Simple Input",
               placeholder: "Enter text",
               text: .constant("sasasa")
           )
           
           CustomTextFieldComponent(
               title: "Multiline Input",
               placeholder: "Enter long text",
               text: .constant("This is some example text\ndzdzd zdz \nococez zdc z "),
               isMultiline: true
           )
           
           CustomTextFieldComponent(
               title: "Secret field",
               placeholder: "Enter your password",
               text: .constant("password"),
               isSecure: true
           )
       }
       .padding()
       .preferredColorScheme(.dark)
       .background(Color(.systemBackground))
   }
}
