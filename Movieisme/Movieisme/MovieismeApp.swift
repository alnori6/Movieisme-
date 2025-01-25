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
            SignUp()
                .environmentObject( movieVM)
        }
    }
}
