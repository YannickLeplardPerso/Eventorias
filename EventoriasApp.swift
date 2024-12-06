//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by Yannick LEPLARD on 10/11/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct EventoriasApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var selectedTab = 0
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                NavigationStack {
                    TabView(selection: $selectedTab) {
                        EventListView()
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("Events")
                            }
                            .tag(0)
                        
                        ProfileView(viewModel: profileViewModel)
                            .tabItem {
                                Image(systemName: "person")
                                Text("Profile")
                            }
                            .tag(1)
                    }
                    .accentColor(.evRed)
                }
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
    }
}
