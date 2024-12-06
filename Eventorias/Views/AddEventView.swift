//
//  AddEventView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI



struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EventViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(spacing: 20) {
                    CustomTextFieldComponent(title: "Title",
                                    placeholder: "New event",
                                    text: $viewModel.newEvent.title)
                    
                    CustomTextFieldComponent(title: "Description",
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
                    
                    CustomTextFieldComponent(title: "Address",
                                    placeholder: "Enter full address",
                                    text: $viewModel.newEvent.location)
                    
                    CategorySelectorComponent(
                        selectedCategory: $viewModel.newEvent.category,
                        title: "Category"
                    )
                    
                    HStack(spacing: 15) {
                        Spacer()
                        Button(action: {}) {
                            VStack {
                                Image(systemName: "camera")
                                    .font(.system(size: 20))
                                    .foregroundColor(.evMainInverted)
                            }
                            .frame(width: 52, height: 52)
                            .background(.evMain)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {}) {
                            VStack {
                                Image(systemName: "paperclip")
                                    .font(.system(size: 20))
                                    .foregroundColor(.evMain)
                            }
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
                viewModel.addEvent {
                    dismiss()
                }
            }) {
                Text("Validate")
                    .foregroundColor(.evMain)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.evRed)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isFormValid)
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
            // temp
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    viewModel.newEvent = Event(
//                        title: "",
//                        description: "",
//                        date: Date(),
//                        location: "",
//                        category: .other,
//                        creatorId: "",
//                        createdAt: Date()
//                    )
//                }) {
//                    Image(systemName: "eraser")
//                        .foregroundColor(.evRed)
//                }
//            }
            // ===
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
