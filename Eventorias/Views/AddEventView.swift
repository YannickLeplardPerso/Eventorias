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
    
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var location = ""
    @State private var category: EventCategory = .other
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Titre", text: $title)
                TextField("Description", text: $description)
                DatePicker("Date", selection: $date)
                TextField("Lieu", text: $location)
                Picker("Catégorie", selection: $category) {
                    ForEach(EventCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                    }
                }
            }
            .navigationTitle("Nouvel événement")
            .navigationBarItems(
                leading: Button("Annuler") { dismiss() },
                trailing: Button("Ajouter") {
                    viewModel.addEvent(
                        title: title,
                        description: description,
                        date: date,
                        location: location,
                        category: category
                    )
                    dismiss()
                }
                .disabled(title.isEmpty || location.isEmpty)
            )
        }
    }
}
