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
                    .padding(.horizontal)
                }
                
                CustomTextFieldComponent(
                    title: "Email",
                    placeholder: "Enter your email",
                    text: $email
                )
                .padding(.horizontal)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                
                CustomTextFieldComponent(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $password,
                    isSecure: true
                )
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    CustomProgressViewComponent()
                } else {
                    Button(action: {
                        if isSignUp {
                            viewModel.signUp(email: email, password: password, name: name) {
                                isPresented = false
                            }
                        } else {
                            viewModel.signIn(email: email, password: password) {
                                isPresented = false
                            }
                        }
                    }) {
                        Text(isSignUp ? "Sign up" : "Sign in")
                            .foregroundColor(.evMain)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.evRed)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        isSignUp.toggle()
                    }) {
                        Text(isSignUp ? "Already have an account? Sign in" : "Don't have an account? Sign up")
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle(isSignUp ? "Sign Up" : "Sign In")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
        .eventAlert(error: $viewModel.error)
    }
}



struct LoginSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSheetView(viewModel: AuthViewModel(), isPresented: .constant(true))
    }
}
