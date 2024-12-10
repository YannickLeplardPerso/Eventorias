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
                        text: $viewModel.newEvent.title)

                    CustomTextFieldComponent(
                        title: "Description",
                        placeholder: "Tap here to enter your description",
                        text: $viewModel.newEvent.description,
                        isMultiline: true)

                    HStack(spacing: 18) {
                        CustomDatePickerComponent(
                            title: "Date",
                            date: $viewModel.newEvent.date,
                            components: .date
                        )

                        CustomDatePickerComponent(
                            title: "Time",
                            date: $viewModel.newEvent.date,
                            components: .hourAndMinute
                        )
                    }

                    CustomTextFieldComponent(
                        title: "Address",
                        placeholder: "Enter full address",
                        text: $viewModel.newEvent.location)

                    CategorySelectorComponent(
                        selectedCategory: $viewModel.newEvent.category,
                        title: "Category"
                    )
                    
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
                        
                        Spacer()
                    }
                }
                .padding()
            }

            Button(action: {
                viewModel.addEventWithImage {
                    dismiss()
                }
            }) {
                if viewModel.isUploading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .evMain))
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
            .disabled(!viewModel.isFormValid || viewModel.isUploading)
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
            }

        }
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
