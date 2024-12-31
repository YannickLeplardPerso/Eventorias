//
//  LoginSheetView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 25/11/2024.
//

import SwiftUI



struct LoginSheetView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isPresented: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isSignUp {
                    CustomTextFieldComponent(
                        title: "Name",
                        placeholder: "Enter your first name and last name",
                        text: $name
                    )
                    .textContentType(.name)
                    .padding(.horizontal)
                    .accessibilityIdentifier(AccessID.signName)
                }
                
                CustomTextFieldComponent(
                    title: "Email",
                    placeholder: "Enter your email",
                    text: $email
                )
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessID.signEmail)
                
                CustomTextFieldComponent(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $password,
                    isSecure: true
                )
                .textContentType(isSignUp ? .newPassword : .password)
                .padding(.horizontal)
                .accessibilityIdentifier(AccessID.signPassword)
                
                if viewModel.isLoading {
                    CustomProgressViewComponent()
                } else {
                    Button(action: {
                        Task {
                            if isSignUp {
                                await viewModel.signUp(email: email, password: password, name: name)
                                isPresented = !viewModel.isAuthenticated
                            } else {
                                await viewModel.signIn(email: email, password: password)
                                isPresented = !viewModel.isAuthenticated
                            }
                        }
                    }) {
                        Text(isSignUp ? "Sign up" : "Sign in")
                            .foregroundColor(.evMain)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(email.isEmpty || password.isEmpty || (isSignUp && name.isEmpty) ? .gray.opacity(0.3) : .evRed)
                            .cornerRadius(8)
                            .cornerRadius(8)
                    }
                    .accessibilityIdentifier(AccessID.signSubmit)
                    .accessibilityLabel(isSignUp ? "Sign up button" : "Sign in button")
                    .disabled(email.isEmpty || password.isEmpty || (isSignUp && name.isEmpty))
                    .padding(.horizontal)
                    
                    Button(action: {
                        isSignUp.toggle()
                    }) {
                        Text(isSignUp ? "Already have an account? Sign in" : "Don't have an account? Sign up")
                            .foregroundColor(.blue)
                    }
                    .accessibilityIdentifier(AccessID.signToggle)
                    .accessibilityLabel(isSignUp ? "Switch to sign in" : "Switch to sign up")
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle(isSignUp ? "Sign Up" : "Sign In")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            }
                .accessibilityIdentifier("cancel-button")
                .accessibilityLabel("Cancel authentication"))
        }
        .eventAlert(error: $viewModel.error)
    }
}



struct LoginSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSheetView(viewModel: AuthViewModel(), isPresented: .constant(true))
    }
}
