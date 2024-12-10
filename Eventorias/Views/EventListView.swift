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
    @State private var selectedSortOption: SortOption = .date
    @State private var selectedEvent: Event?
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarComponent(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                
                SortButtonComponent(action: {
                    showingSortOptions = true
                })
                .padding(.horizontal)
                
                List {
                    if viewModel.events.isEmpty {
                        Text("No events yet")
                            .foregroundColor(.evGray)
                    } else {
                        ForEach(viewModel.filteredEvents) { event in
                            Button {
                                selectedEvent = event
                            } label: {
                                EventCardComponent(event: event)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
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
                    .padding(.trailing, 20)
                    .padding(.bottom, 70) // Pour être au-dessus de la TabView
                }
            }
        }
        .onAppear {
            viewModel.fetchEvents()
        }
        .navigationDestination(isPresented: Binding(get: { selectedEvent != nil },
                                                    set: { if !$0 { selectedEvent = nil } })) {
            if let event = selectedEvent {
                EventDetailView(event: event)
            }
        }
        .actionSheet(isPresented: $showingSortOptions) {
            ActionSheet(
                title: Text("Sort events"),
                buttons: [
                    .default(Text("By date")) { selectedSortOption = .date },
                    .default(Text("By category")) { selectedSortOption = .category },
                    .cancel()
                ]
            )
        }
        .onChange(of: selectedSortOption) { oldValue, newValue in
            viewModel.sortEvents(by: newValue)
        }
    }
}



struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventListView()
        }
    }
}
