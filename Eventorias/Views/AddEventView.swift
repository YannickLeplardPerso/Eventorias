//
//  AddEventView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI
import PhotosUI



struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EventViewModel
    
    @State private var showCamera = false

    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(spacing: 20) {
                    CustomTextFieldComponent(
                        title: "Title",
                        placeholder: "New event",
                        text: $viewModel.newEvent.title
                    )
                    .accessibilityIdentifier("event-title-input")

                    CustomTextFieldComponent(
                        title: "Description",
                        placeholder: "Tap here to enter your description",
                        text: $viewModel.newEvent.description,
                        isMultiline: true
                    )
                    .accessibilityIdentifier("event-description-input")

                    HStack(spacing: 18) {
                        CustomDatePickerComponent(
                            title: "Date",
                            date: $viewModel.newEvent.date,
                            components: .date
                        )
                        .accessibilityIdentifier("event-date-picker")

                        CustomDatePickerComponent(
                            title: "Time",
                            date: $viewModel.newEvent.date,
                            components: .hourAndMinute
                        )
                        .accessibilityIdentifier("event-time-picker")
                    }

                    CustomTextFieldComponent(
                        title: "Address",
                        placeholder: "Enter full address",
                        text: $viewModel.newEvent.location.address
                    )
                    .textContentType(.fullStreetAddress)
                    .accessibilityIdentifier("event-address-input")

                    CategorySelectorComponent(
                        selectedCategory: $viewModel.newEvent.category,
                        title: "Category"
                    )
                    .accessibilityIdentifier("category-selector")
                    
                    HStack(spacing: 15) {
                        Spacer()
                        
                        Button(action: {
                            showCamera = true
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 20))
                                .foregroundColor(.evMainInverted)
                                .frame(width: 52, height: 52)
                                .background(.evMain)
                                .cornerRadius(10)
                        }
                        .accessibilityLabel("Take photo")
                        .accessibilityHint("Opens camera to take event photo")
                        .accessibilityIdentifier("camera-button")
                        .sheet(isPresented: $showCamera) {
                            ImagePickerComponent(selectedImage: $viewModel.selectedImage)
                        }
                        
                        PhotosPicker(selection: $viewModel.selectedItem,
                                     matching: .images) {
                            Image(systemName: "paperclip")
                                .font(.system(size: 20))
                                .foregroundColor(.evMain)
                                .frame(width: 52, height: 52)
                                .background(.evRed)
                                .cornerRadius(10)
                        }
                        // ???
                                     .accessibilityLabel("Choose photo")
                                     .accessibilityHint("Opens photo library to choose event image")
                                     .accessibilityIdentifier("photo-picker-button")
                        
                        Spacer()
                    }
                }
                .padding()
            }

            Button(action: {
                Task {
                    do {
                        if viewModel.newEvent.title.isEmpty {
                            viewModel.error = .titleRequired
                            return
                        }
                        if viewModel.newEvent.location.address.isEmpty {
                            viewModel.error = .addressRequired
                            return
                        }
                        await viewModel.geocodeAddress(viewModel.newEvent.location.address)
                        
                        try await viewModel.addEventWithImage()
                        dismiss()
                    } catch {
                        if let eventError = error as? EventError {
                            viewModel.error = eventError
                        } else {
                            viewModel.error = .eventCreationFailed
                        }
                    }
                }
            }) {
                if viewModel.isLoading {
                    CustomProgressViewComponent()
                } else {
                    Text("Validate")
                        .foregroundColor(.evMain)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.evRed)
                        .cornerRadius(10)
                }
            }
            .accessibilityLabel("Create event")
            .accessibilityHint(viewModel.isFormValid ? "Double tap to create event" : "Form is incomplete")
            .accessibilityIdentifier("create-event-button")
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.evMain)
                    Text("Creation of an event")
                        .foregroundColor(.evMain)
                        .font(.headline)
                }
                .accessibilityLabel("Back to events")
            }

        }
        .eventAlert(error: $viewModel.error)
    }
}



struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddEventView(viewModel: EventViewModel())
        }
        .preferredColorScheme(.dark)
    }
}
