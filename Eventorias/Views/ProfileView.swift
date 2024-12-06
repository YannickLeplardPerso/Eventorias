//
//  ProfileView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("User profile")
                    .foregroundColor(.evMain)
                    .font(.system(size: 20))
                
                Spacer()
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let imageUrl = viewModel.profileImageUrl {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.evGray)
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.evGray)
                            .font(.system(size: 60))
                    }
                }
            }
            .padding()
            
            CustomTextFieldComponent(
                title: "Name",
                placeholder: "",
                text: $viewModel.userName
            )
            .disabled(true)
            .padding(.horizontal)
            .onChange(of: viewModel.userName) { oldValue, newValue in
                viewModel.updateUserProfile()
            }
            
            CustomTextFieldComponent(
                title: "E-mail",
                placeholder: "",
                text: $viewModel.userEmail
            )
            .disabled(true)
            .padding(.horizontal)
            
            HStack {
                Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                    .tint(.evRed)
                    .labelsHidden()
                
                Text("Notifications")
                    .foregroundColor(.evGray)
                
                Spacer()
            }
            .padding(.horizontal)
                    
            Spacer()
        }
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.selectedImage = image
                }
            }
        }
        .onChange(of: viewModel.selectedImage) { oldImage, newImage in
            if let image = newImage {
                viewModel.uploadProfileImage(image)
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .background(Color.black.opacity(0.4))
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var mockViewModel: ProfileViewModel = {
        let viewModel = ProfileViewModel()
        viewModel.userName = "John Doe"
        viewModel.userEmail = "john.doe@example.com"
        viewModel.notificationsEnabled = true
        return viewModel
    }()
    
    static var previews: some View {
        NavigationStack {
            ProfileView(viewModel: mockViewModel)
        }
        .preferredColorScheme(.dark)
    }
}
