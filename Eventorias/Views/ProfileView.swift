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
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var showLibrary = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("User profile")
                    .foregroundColor(.evMain)
                    .font(.system(size: 20))
                    .accessibilityAddTraits(.isHeader)
                
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
                .accessibilityLabel("Profile picture")
                .accessibilityHint("Double tap to change profile picture")
                .accessibilityIdentifier(AccessID.profileImage)
            }
            .padding()
            
            CustomTextFieldComponent(
                title: "Name",
                placeholder: "",
                text: $viewModel.userName
            )
            .accessibilityIdentifier(AccessID.profileUsername)
            .disabled(true)
            .padding(.horizontal)
            .onChange(of: viewModel.userName) { oldValue, newValue in
                Task {
                    await viewModel.updateUserProfile()
                }
            }
            
            CustomTextFieldComponent(
                title: "E-mail",
                placeholder: "",
                text: $viewModel.userEmail
            )
            .accessibilityIdentifier(AccessID.profileEmail)
            .disabled(true)
            .padding(.horizontal)
            
            HStack {
                Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                    .tint(.evRed)
                    .labelsHidden()
                    .accessibilityLabel("Enable notifications")
                    .accessibilityIdentifier(AccessID.profileNotifications)
                
                Text("Notifications")
                    .foregroundColor(.evGray)
                    .accessibilityHidden(true)
                
                Spacer()
            }
            .padding(.horizontal)
                    
            Spacer()
        }
        // ya
        .onAppear {
            Task {
                await viewModel.reloadUserProfile()
            }
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
                      selection: $viewModel.selectedItem,
                      matching: .images)
        .overlay {
            if viewModel.isLoading {
                CustomProgressViewComponent()
            }
        }
        .eventAlert(error: $viewModel.error)
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
