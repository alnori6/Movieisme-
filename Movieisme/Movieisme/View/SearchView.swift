////
////  SearchView.swift
////  Movieisme
////
////  Created by Noori on 30/01/2025.
////
//
//import SwiftUI
//
//struct SearchView: View {
//    @EnvironmentObject private var movieVM: movieViewModel
//    
//    @State private var searchQuery = ""
//    @State private var searchResults: [SearchResult] = []
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            
//            // 🔍 Search Bar
//            HStack {
//                TextField("Search for movies, actors...", text: $searchQuery)
//                    .padding(8)
//                    .padding(.horizontal, 24)
//                    .background(Color.white.opacity(0.2))
//                    .cornerRadius(8)
//                    .overlay(
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(.gray)
//                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                                .padding(.leading, 8)
//                        }
//                    )
//                    .onChange(of: searchQuery) { newValue in
//                        searchResults = movieVM.searchMoviesActorsDirectors(query: newValue)
//                    }
//                
//                // ❌ Clear Search Button
//                if !searchQuery.isEmpty {
//                    Button(action: {
//                        searchQuery = ""
//                        searchResults.removeAll()
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                            .padding(.trailing, 8)
//                    }
//                }
//            }
//            .padding(.horizontal)
//
//            // 🔎 Display Results Below the Search Bar
//            if !searchResults.isEmpty {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 10) {
//                        ForEach(searchResults) { result in
//                            NavigationLink(destination: getResultDestination(result: result)) {
//                                HStack {
//                                    Text(result.name)
//                                        .font(.system(size: 16, weight: .medium))
//                                        .foregroundColor(.white)
//                                    
//                                    Spacer()
//                                    
//                                    Text(getResultIcon(result.type))
//                                        .font(.system(size: 14))
//                                        .foregroundColor(.gray)
//                                }
//                                .padding()
//                                .background(Color("Dark2"))
//                                .cornerRadius(8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .frame(height: 300) // Limiting height for better UI
//            }
//
//            Spacer()
//        }
//        .navigationTitle("Search")
//    }
//    
//    // Helper Function to Get Icon Representation
//    func getResultIcon(_ type: SearchResultType) -> String {
//        switch type {
//        case .movie:
//            return "🎬 Movie"
//        case .actor:
//            return "🎭 Actor"
//        case .director:
//            return "🎬 Director"
//        }
//    }
//    
//    // Helper Function to Get Navigation Destination
//    @ViewBuilder
//    func getResultDestination(result: SearchResult) -> some View {
//        switch result.type {
//        
//        case .movie:
//            let matchingMovies = movieVM.movies.filter { $0.fields.name.localizedCaseInsensitiveContains(result.name) }
//            
//            if matchingMovies.isEmpty {
//                Text("No movies found")
//                    .foregroundColor(.gray)
//                    .font(.system(size: 18))
//                    .padding()
//            } else {
//                ScrollView {
//                    LazyVStack(spacing: 10) {
//                        ForEach(matchingMovies, id: \.id) { movie in
//                            NavigationLink(destination: MovieInfo(movie: movie)) {
//                                MovieMiniCard(movie: movie)
//                                    .frame(width: 172, height: 237)
//                                    .cornerRadius(8)
//                                    .padding(.vertical, 5)
//                            }
//                        }
//                    }
//                    .padding()
//                }
//                .navigationTitle("Movies: \(result.name)")
//            }
//
//        case .actor:
//            if let actor = movieVM.actors.first(where: { $0.id == result.id }) {
//                VStack {
//                    AsyncImage(url: URL(string: actor.fields.image)) { image in
//                        image.resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 150)
//                            .clipShape(Circle())
//                    } placeholder: {
//                        ProgressView()
//                    }
//                    .padding()
//
//                    Text(actor.fields.name)
//                        .font(.title)
//                        .bold()
//                }
//                .navigationTitle("Actor Info")
//            } else {
//                Text("Actor not found")
//            }
//
//        case .director:
//            if let director = movieVM.directors.first(where: { $0.id == result.id }) {
//                VStack {
//                    AsyncImage(url: URL(string: director.fields.image)) { image in
//                        image.resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 150)
//                            .clipShape(Circle())
//                    } placeholder: {
//                        ProgressView()
//                    }
//                    .padding()
//
//                    Text(director.fields.name)
//                        .font(.title)
//                        .bold()
//                }
//                .navigationTitle("Director Info")
//            } else {
//                Text("Director not found")
//            }
//        }
//    }
//    
//}
//
//#Preview {
//    SearchView()
//        .environmentObject(movieViewModel())
//}
