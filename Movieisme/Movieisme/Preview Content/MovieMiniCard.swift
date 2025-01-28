//
//  MovieMiniCard.swift
//  Movieisme
//
//  Created by Noori on 25/01/2025.
//

import SwiftUI

struct MovieMiniCard: View {
    
    @StateObject var movieVM = movieViewModel()

    /// Maximum possible rating (usually 5)
    let maxRating: Int = 5

    let movie: MoviesRecord
    
    var body: some View {
        
        
    
        AsyncImage(url: URL(string: movie.fields.poster)) { image in
            image.resizable()
                .scaledToFill()
            
        } placeholder: {
            ProgressView("Loading...")
        }
        .frame(width: 208, height: 275)
        .cornerRadius(8)
        .clipped()
            
        
    }
    
}

#Preview {
//    MovieMiniCard()
    
    MovieMiniCard(movie: MoviesRecord(
        id: "1",
        createdTime: "0000-00-00T00:00:00Z",
        fields: IndigoFields(
            name: "Top Gun",
            rating: "",
            genre: ["Action"],
            poster: "https://i.pinimg.com/736x/0e/e3/41/0ee34190d837ddf0048c2caf14a2ff8e.jpg",
            language: ["English"],
            imDBRating: 9.6,
            runtime: "2 hr 9 min",
            story: "Pete “Maverick” Mitchell is a hotshot Navy pilot whose skill is as legendary as his reckless streak. Sent to the elite TOPGUN program with his partner, “Goose,” Maverick competes against the best while wrestling with personal guilt and the shadow of his father’s mysterious past. A tragic loss forces him to overcome fear and self-doubt, pushing him to prove he’s more than just a daredevil. With everything on the line—his career, his confidence, and even a new romance—Maverick must rise above his own limits to claim his spot among the Navy’s top pilots."
            
        )
    ))
}
