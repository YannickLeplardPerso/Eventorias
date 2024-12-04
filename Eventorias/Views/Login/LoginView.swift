//
//  LoginView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 13/11/2024.
//

import SwiftUI
import FirebaseAuth



struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showLoginSheet = false
    
    var body: some View {
        VStack {
            Image("Logo_Eventorias")
                .resizable()
                .scaledToFit()
                .frame(height: UIScreen.main.bounds.height / 3)
                .padding(.top, 120)
                .padding(.horizontal, 74)
            
            Button(action: {
                showLoginSheet = true
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.evMain)
                        .font(.system(size: 16))
                    
                    Text("Sign in with email")
                        .foregroundColor(.evMain)
                        .font(.system(size: 16))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.evRed)
                .cornerRadius(8)
                .padding(.horizontal, 74)
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showLoginSheet) {
            LoginSheetView(viewModel: viewModel, isPresented: $showLoginSheet)
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel())
    }
}
