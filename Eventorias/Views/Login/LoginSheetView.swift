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
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .foregroundColor(.evMain)
                    .padding(6)
                    .background(.evBackground)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .accessibility(label: Text("Email input field"))
                
                SecureField("Password", text: $password)
                    .foregroundColor(.evMain)
                    .padding(6)
                    .background(.evBackground)
                    .cornerRadius(6)
                    .padding(.horizontal)
                    .accessibility(label: Text("Password input field"))
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        if isSignUp {
                            viewModel.signUp(email: email, password: password) {
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
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}



struct LoginSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSheetView(viewModel: AuthViewModel(), isPresented: .constant(true))
    }
}
