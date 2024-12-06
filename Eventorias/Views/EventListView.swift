//
//  EventListView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 25/11/2024.
//

import SwiftUI



struct EventListView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var searchText = ""
    @State private var showingSortOptions = false
    @State private var selectedSortOption: SortOption = .date
    
    enum SortOption {
        case date, category, title
    }
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarComponent(text: $searchText)
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
                        ForEach(viewModel.events) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventCardComponent(event: event)
                            }
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
        .actionSheet(isPresented: $showingSortOptions) {
            ActionSheet(
                title: Text("Sort events"),
                buttons: [
                    .default(Text("By date")) { selectedSortOption = .date },
                    .default(Text("By category")) { selectedSortOption = .category },
                    .default(Text("By title")) { selectedSortOption = .title },
                    .cancel()
                ]
            )
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
