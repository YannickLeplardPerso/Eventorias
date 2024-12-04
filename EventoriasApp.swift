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
    @State private var selectedTab = 0
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                TabView(selection: $selectedTab) {
                    Spacer()
                    NavigationStack {
                        EventListView()
                    }
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Events")
                    }
                    .tag(0)
                    
                    NavigationStack {
                        ProfileView()
                    }
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(1)
                    
                    Spacer()
                }
                .accentColor(.evRed)
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
    }
}