//
//  EventListView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 25/11/2024.
//

import SwiftUI



struct EventListView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var showingSortOptions = false
    @State private var selectedEvent: Event?
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarComponent(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .accessibilityIdentifier(AccessID.eventSearch)
                
                SortButtonComponent(
                    selectedSort: $viewModel.currentSort,
                    onSortSelected: { option in
                        viewModel.applySort(option)
                    }
                )
                .padding(.horizontal)
                .accessibilityIdentifier(AccessID.eventSort)
                
                List {
                    if viewModel.events.isEmpty {
                        Text("No events yet")
                            .foregroundColor(.evGray)
                            .accessibilityLabel("No events available")
                    } else {
                        ForEach(viewModel.filteredEvents) { event in
                            Button {
                                selectedEvent = event
                            } label: {
                                EventCardComponent(event: event)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                            }
                            .accessibilityIdentifier(AccessID.eventCard(event.id ?? ""))
                            .accessibilityLabel("Event: \(event.title)")
                            .accessibilityHint("Double tap to view event details")
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .accessibilityIdentifier(AccessID.eventList)
            }
            .padding(.bottom)
            
            // Bouton flottant
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: AddEventView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.evMain)
                            .frame(width: 45, height: 45)
                            .background(.evRed)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 4)
                    }
                    .accessibilityIdentifier(AccessID.eventAdd)
                    .accessibilityLabel("Add new event")
                    .accessibilityHint("Opens form to create new event")
                    .padding(.trailing, 20)
                    .padding(.bottom, 70)
                }
            }
        }
        .accessibilityIdentifier(AccessID.eventView)
        .onAppear {
            viewModel.fetchEvents()
        }
        .navigationDestination(isPresented: Binding(get: { selectedEvent != nil },
                                                  set: { if !$0 { selectedEvent = nil } })) {
            if let event = selectedEvent {
                EventDetailView(viewModel: viewModel, event: event)
            }
        }
        .eventAlert(error: $viewModel.error)
    }
}



struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventListView()
        }
    }
}
