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
                      // Attempt to load the logged-in user when the app starts
                      movieVM.loadUsers() // Ensure users are loaded
                      movieVM.loadLoggedInUser()
                  }
          }
      }
  }

  // RootView dynamically decides which view to show based on the logged-in state
  struct RootView: View {
      @EnvironmentObject var movieVM: movieViewModel
      
      var body: some View {
          if movieVM.loggedInUser != nil {
              // Navigate to Home if user is already logged in
              Home()
          } else {
              // Show SignUp if no user is logged in
              SignUp()
          }
      }
  }
