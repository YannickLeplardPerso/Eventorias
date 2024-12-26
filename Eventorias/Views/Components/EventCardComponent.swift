//
//  EventCardComponent.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 04/12/2024.
//

import SwiftUI
import FirebaseFirestore



struct EventCardComponent: View {
    let event: Event
    @State private var creatorPhotoURL: String?
    
    var body: some View {
        HStack {
            if let photoURL = creatorPhotoURL,
               let url = URL(string: photoURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .accessibilityHidden(true)
                    case .failure, .empty:
                        fallbackProfileImage
                    @unknown default:
                        fallbackProfileImage
                    }
                }
                .padding()
            } else {
                fallbackProfileImage
                    .padding()
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.system(size: 16))
                    .foregroundColor(.evGray)
                    .padding(.bottom, 3)
                
                Text(event.formattedDate)
                    .font(.system(size: 14))
                    .foregroundColor(.evGray)
                    .padding(.top, 3)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Event: \(event.title), Date: \(event.formattedDate)")
            
            
            Spacer()
            
            if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    CustomProgressViewComponent()
                }
                .frame(width: 136, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading)
                .accessibilityLabel("Event image")
            } else {
                Rectangle()
                    .fill(Color.evRed)
                    .frame(width: 136, height: 80)
                    .cornerRadius(10)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.evGray)
                            .font(.system(size: 40))
                    )
                    .padding(.leading)
                    .accessibilityHidden(true)
            }
        }
        .onAppear {
            loadCreatorInfo()
        }
        .background(.evBackground)
        .cornerRadius(8)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isButton)
    }
    
    private func loadCreatorInfo() {
        let db = Firestore.firestore()
        db.collection("users").document(event.creatorId).getDocument { document, error in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    creatorPhotoURL = document.data()?["profileImageUrl"] as? String
                }
            }
        }
    }
    
    private var fallbackProfileImage: some View {
        Circle()
            .fill(Color.evBackground)
            .frame(width: 40, height: 40)
            .overlay(
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.evGray)
                    .font(.system(size: 40))
            )
    }
}



struct EventCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        EventCardComponent(event: Event(
            id: "1",
            title: "Conférence SwiftUI",
            description: "Une session interactive pour apprendre SwiftUI avec des experts.",
            date: Date(),
            location: EventLocation(
                address: "Palais des Congrès, 2 Place de la Porte Maillot, 75017 Paris",
                latitude: 48.8785,
                longitude: 2.2833
            ),
            category: .business,
            creatorId: "123",
            createdAt: Date()
        ))
        .previewLayout(.sizeThatFits)
    }
}
