//
//  SeeMore.swift
//  Movieisme
//
//  Created by Noori on 30/01/2025.
//

import SwiftUI

import SwiftUI


struct SeeMore: View {
    var title: String
    var movies: [MoviesRecord]

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(movies, id: \.id) { movie in
                            
                            NavigationLink(destination: MovieInfo(movie: movie)) {
                                MovieMiniCard(movie: movie)
                                    .frame(width: 172, height: 237) // Maintains correct size
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    
                }
//                .padding(.top, 16)
                    
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 28, weight: .bold, design: .default))
                }
            }
           
        }
    }
}

#Preview {
    SeeMore(title: "Drama Movies", movies: [
        MoviesRecord(
            id: "movie123",
            createdTime: "2025-01-30T10:00:00Z",
            fields: IndigoFields(
                name: "Sample Movie",
                rating: "PG-13",
                genre: ["Drama"],
                poster: "https://i.imghippo.com/files/snS1877oNU.jpg",
                language: ["English"],
                imDBRating: 8.5,
                runtime: "2h 10m",
                story: "A dramatic tale of courage and resilience."
            )
        ),
        MoviesRecord(
            id: "movie123",
            createdTime: "2025-01-30T10:00:00Z",
            fields: IndigoFields(
                name: "Sample Movie",
                rating: "PG-13",
                genre: ["Drama"],
                poster: "https://i.imghippo.com/files/snS1877oNU.jpg",
                language: ["English"],
                imDBRating: 8.5,
                runtime: "2h 10m",
                story: "A dramatic tale of courage and resilience."
            )
        ),
        MoviesRecord(
            id: "movie123",
            createdTime: "2025-01-30T10:00:00Z",
            fields: IndigoFields(
                name: "Sample Movie",
                rating: "PG-13",
                genre: ["Drama"],
                poster: "https://i.imghippo.com/files/snS1877oNU.jpg",
                language: ["English"],
                imDBRating: 8.5,
                runtime: "2h 10m",
                story: "A dramatic tale of courage and resilience."
            )
        )
    ])
    .environmentObject(movieViewModel())
}
