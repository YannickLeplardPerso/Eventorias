//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 05/12/2024.
//

import SwiftUI
import MapKit

import FirebaseFirestore



struct EventDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EventViewModel
    let event: Event
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                                    .clipped()
                                    .cornerRadius(10)
                            case .failure(_):
                                fallbackImage
                            case .empty:
                                CustomProgressViewComponent()
                            @unknown default:
                                fallbackImage
                            }
                        }
                    } else {
                        fallbackImage
                    }
                }
                .padding(.horizontal, 20)
                
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.evMain)
                                .font(.system(size: 16))
                            
                            Text(event.formattedDate)
                                .foregroundColor(.evMain)
                                .font(.system(size: 16))
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .foregroundColor(.evMain)
                                .font(.system(size: 16))
                            
                            Text(event.formattedTime)
                                .foregroundColor(.evMain)
                                .font(.system(size: 16))
                        }
                    }
                    
                    Spacer()
                    
                    if let photoURL = viewModel.creatorPhotoURL,
                       let url = URL(string: photoURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            case .failure, .empty:
                                fallbackProfileImage
                            @unknown default:
                                fallbackProfileImage
                            }
                        }
                    } else {
                        fallbackProfileImage
                    }
                }
                .padding(.horizontal)
                
                Text(event.description)
                    .foregroundColor(.evMain)
                    .font(.system(size: 14))
                    .padding(.horizontal)
                
                HStack(spacing: 24) {
                    Text(event.location)
                        .foregroundColor(.evMain)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Map(position: $viewModel.cameraPosition) {
                        if let location = viewModel.eventLocation {
                            Annotation(event.title, coordinate: location) {
                                Image(systemName: "mappin")
                                    .foregroundColor(.red)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .mapStyle(.standard)
                    .frame(width: 150, height: 72)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.evMain)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(event.title)
                    .foregroundColor(.evMain)
            }
        }
        .onAppear {
            viewModel.loadCreatorInfo(for: event.creatorId)
            viewModel.geocodeLocation(address: event.location)
        }
        .eventAlert(error: $viewModel.error)
    }
    
    private var fallbackImage: some View {
        Rectangle()
            .fill(Color.evBackground)
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
            .cornerRadius(10)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.evGray)
                    .font(.system(size: 40))
            )
    }
    
    private var fallbackProfileImage: some View {
        Circle()
            .fill(Color.evBackground)
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.evGray)
                    .font(.system(size: 60))
            )
    }
}



struct EventDetailView_Previews: PreviewProvider {
    static var sampleEvent = Event(
        title: "Concert Rock",
        description: "Un super concert de rock avec les meilleurs groupes du moment. Venez nombreux pour une soirée inoubliable remplie de musique et d'énergie !",
        date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
        location: "Zénith de Paris, 211 Avenue Jean Jaurès, 75019 Paris",
        category: .music,
        creatorId: "user123",
        createdAt: Date()
    )
    
    static var previews: some View {
        NavigationStack {
            EventDetailView(
                viewModel: EventViewModel(),
                event: sampleEvent
            )
        }
        .preferredColorScheme(.dark)
    }
}
