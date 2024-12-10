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
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var showLibrary = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("User profile")
                    .foregroundColor(.evMain)
                    .font(.system(size: 20))
                
                Spacer()
                
                Button {
                    showActionSheet = true
                } label: {
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
        .confirmationDialog("Choose Photo", isPresented: $showActionSheet) {
            Button("Photo Library") {
                showLibrary = true
            }
            
            Button("Take Photo") {
                showImagePicker = true
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerComponent(selectedImage: $viewModel.selectedImage)
        }
        .photosPicker(isPresented: $showLibrary,
                      selection: $selectedItem,
                      matching: .images)
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.selectedImage = image
                    viewModel.uploadProfileImage(image)
                }
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
