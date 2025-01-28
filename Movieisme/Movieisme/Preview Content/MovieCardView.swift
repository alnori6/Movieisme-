//
//  MovieCardView.swift
//  Movieisme
//
//  Created by Noori on 18/01/2025.
//

import SwiftUI
import Combine

struct MovieCardView: View {
    //    @EnvironmentObject private var viewModel : movieViewModel
    @StateObject var movieVM = movieViewModel()
    
   
   /// Maximum possible rating (usually 5)
   let maxRating: Int = 5
    
    let movie: MoviesRecord
//    var director: DirecrtorsRecord
    
    var body: some View {
        
        let ratingDouble = movieVM.convertRatingOutOfTenToFive(movie.fields.imDBRating)
        
            ZStack(alignment: .bottomLeading) {
                // Movie Poster
                AsyncImage(url: URL(string: movie.fields.poster)) { image in
                    image.resizable()
                        .scaledToFill()
                    
                } placeholder: {
                    ProgressView("Loading...")
                }
                .frame(width: 366, height: 424)
                .cornerRadius(8)
                .clipped()
                
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(width: 366, height: 424)
                
                
                
                
                // Movie Info Overlay
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(movie.fields.name)
                        .font(.system(size: 22, weight: .bold, design: .default))
                    
                    HStack(spacing: 0) {
                        ForEach(1...maxRating, id: \.self) { index in
                            Image(systemName: index <= Int(floor(ratingDouble)) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.system(size: 9, weight: .medium, design: .default))
                        }
                    }
                    
                    HStack(){
                        Text("\(ratingDouble, specifier: "%.1f") ")
                            .font(.system(size: 20, weight: .medium, design: .default))
                        
                        Text("out of 5")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .padding(.leading, -4)
                    }
                    
                    
                    Text("\(movie.fields.genre.joined(separator: ", ")) . \(movie.fields.runtime)")
                        .font(.system(size: 12, weight: .medium, design: .default))
                    
                    
                }
                .padding(8)
                
                
                
                
                
            }
            .onAppear {
                movieVM.loadMovies()
            }
  
        
        
    }
    
}

#Preview {
    MovieCardView(
        movie: MoviesRecord(
        id: "reckJmZ458CZcLlUd",
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
        )
        
    
    )
    .environmentObject(movieViewModel())
    //    MovieCardView()
    //        .environmentObject(movieViewModel())
}
