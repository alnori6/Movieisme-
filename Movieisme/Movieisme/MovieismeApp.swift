//
//  MovieismeApp.swift
//  Movieisme
//
//  Created by Noori on 16/01/2025.
//

import SwiftUI

@main
struct MovieismeApp: App {
    
    @StateObject private var movieVM = movieViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(movieVM)
                .onAppear {
                    // Load users and restore the logged-in session
                    movieVM.loadUsers()
                    movieVM.loadLoggedInUser()
                }
        }
    }
}

// MARK: - RootView dynamically decides which view to show based on login state
struct RootView: View {
    @EnvironmentObject var movieVM: movieViewModel
    
    var body: some View {
        Group {
            if movieVM.loggedInUser != nil {
                Home() // Show Home if logged in
            } else {
                SignUp() // Show Sign-Up/Login screen if not logged in
            }
        }
        .onAppear {
            // Ensure session restoration in case it was missed
            movieVM.loadLoggedInUser()
        }
    }
}
