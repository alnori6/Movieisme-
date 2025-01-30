//
//  Home.swift
//  Movieisme
//
//  Created by Noori on 18/01/2025.
//

import SwiftUI

struct Home: View {
    
//    @StateObject private var movieVM = movieViewModel()
    @EnvironmentObject private var movieVM : movieViewModel
    @State private var selectedPage = 0 // To track the current page
    
    @State private var searchQuery = ""
    @State private var searchResults: [SearchResult] = []
    
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
                Spacer().frame(height: 16)
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Search for movies, actors...", text: $searchQuery)
                            .padding(8)
                            .padding(.horizontal, 24)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 8)
                                }
                            )
                            .onChange(of: searchQuery) { newValue in
                                searchResults = movieVM.searchMoviesActorsDirectors(query: newValue)
                            }
                        
                        // 🔎 Display Results
                        if !searchResults.isEmpty {
                            List(searchResults) { result in
                                HStack {
                                    Text(result.name)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Text(result.type == .movie ? "🎬 Movie" : result.type == .actor ? "🎭 Actor" : "🎬 Director")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 24)
                    
                    Text("High Rated")
                        .font(.system(size: 22, weight: .semibold, design: .default))
                        .padding(.horizontal)

                        
                    Spacer().frame(height: 16)
                    
                    // MARK: - the tabview for the movies whole
                    TabView(selection: $selectedPage) {
                        ForEach(movieVM.heighRatedMovies.indices, id: \.self) { index in
                            NavigationLink(destination: MovieInfo(movie: movieVM.heighRatedMovies[index])) {
                                MovieCardView(movie: movieVM.heighRatedMovies[index])
                                    .tag(index)
                            }.buttonStyle(.plain)
                            
//                                .environmentObject(movieVM)// Use the MovieCard component here
                        }
                        
                    }
                    .onAppear {
                        movieVM.loadMovies()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 424)
                   .tabViewStyle(.page(indexDisplayMode: .never))
                   .containerRelativeFrame(Axis.Set.horizontal, alignment: .center)
                    
                   
                    // Custom page indicator
                    HStack(spacing: 8) {
                        Spacer()
                        ForEach(movieVM.heighRatedMovies.indices, id: \.self) { index in
                            Circle()
                                .frame(width: index == selectedPage ? 12 : 8, height: index == selectedPage ? 12 : 8)
                                .foregroundColor(index == selectedPage ? .white : .gray)
                                .opacity(index == selectedPage ? 1 : 0.6)
                        }
                        Spacer()
                    }
                    .padding(.top, 16) // Add spacing between TabView and dots
                    
                    
                    //MARK: - Drama part
                    Spacer().frame(height: 40)
                    
                    HStack(){
                        Text(
                            movieVM.movies.contains { $0.fields.genre.contains("Drama") }
                            ? "Drama"
                            : " "
                        )
                        .font(.system(size: 22, weight: .semibold))
//                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        NavigationLink(destination: SeeMore(title: "Drama Movies", movies: movieVM.dramaMovies)) {
                                Text("Show more")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 14, weight: .medium))
                            }
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 16){
                            ForEach(movieVM.dramaMovies.prefix(4).indices, id: \.self) { index in
                                NavigationLink(destination: MovieInfo(movie: movieVM.dramaMovies[index])) {
                                    MovieMiniCard(movie: movieVM.dramaMovies[index])
                                        .tag(index)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    
                    //MARK: - Comedy part
                    Spacer().frame(height: 40)
                    
                    HStack(){
                        Text(
                            movieVM.movies.contains { $0.fields.genre.contains("Comedy") }
                            ? "Comedy"
                            : ""
                        )
                        .font(.system(size: 22, weight: .semibold))
//                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        NavigationLink(destination: SeeMore(title: "Comedy Movies", movies: movieVM.comedyMovies)) {
                                Text("Show more")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 14, weight: .medium))
                            }
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 16){
                            ForEach(movieVM.comedyMovies.indices, id: \.self) { index in
                                NavigationLink(destination: MovieInfo(movie: movieVM.comedyMovies[index])) {
                                    MovieMiniCard(movie: movieVM.comedyMovies[index])
                                        .tag(index)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    
                    
                    
                    //MARK: - Action part
                    Spacer().frame(height: 40)
                    
                    HStack(){
                        Text(
                            movieVM.movies.contains { $0.fields.genre.contains("Action") }
                            ? "Action"
                            : ""
                        )
                        .font(.system(size: 22, weight: .semibold))
//                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        NavigationLink(destination: SeeMore(title: "Action Movies", movies: movieVM.ActionMovies)) {
                                Text("Show more")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 14, weight: .medium))
                            }
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 16){
                            ForEach(movieVM.ActionMovies.indices, id: \.self) { index in
                                NavigationLink(destination: MovieInfo(movie: movieVM.ActionMovies[index])) {
                                    MovieMiniCard(movie: movieVM.ActionMovies[index])
                                        .tag(index)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    

                    
                    //MARK: - ThrillerMovies part
                    Spacer().frame(height: 40)
                    
                    HStack(){
                        Text(
                            movieVM.movies.contains { $0.fields.genre.contains("Thriller") }
                            ? "Thriller"
                            : ""
                        )
                        .font(.system(size: 22, weight: .semibold))
//                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        NavigationLink(destination: SeeMore(title: "Thriller Movies", movies: movieVM.ThrillerMovies)) {
                                Text("Show more")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 14, weight: .medium))
                            }
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 16){
                            ForEach(movieVM.ThrillerMovies.indices, id: \.self) { index in
                                NavigationLink(destination: MovieInfo(movie: movieVM.ThrillerMovies[index])) {
                                    MovieMiniCard(movie: movieVM.ThrillerMovies[index])
                                        .tag(index)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    
                    
                    
                    //MARK: - CrimeMovies part
                    Spacer().frame(height: 40)
                    
                    HStack(){
                        Text(
                            movieVM.movies.contains { $0.fields.genre.contains("Crime") }
                            ? "Crime"
                            : ""
                        )
                        .font(.system(size: 22, weight: .semibold))
//                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        Text("Show more")
                            .foregroundColor(.accent)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 16){
                            ForEach(movieVM.CrimeMovies.indices, id: \.self) { index in
                                NavigationLink(destination: MovieInfo(movie: movieVM.CrimeMovies[index])) {
                                    MovieMiniCard(movie: movieVM.CrimeMovies[index])
                                        .tag(index)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    
                    
                    
                    
                    
                }// end of the big vstack
                .frame(maxWidth: .infinity, alignment: .leading)
                
            } // end scroll view
            .toolbar() {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Movies Center")
                        .font(.system(size: 28, weight: .bold, design: .default))
//                        .padding(.bottom, 16)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Profile() .environmentObject(movieVM)
                                   , label: {
                        if let user = movieVM.loggedInUser {
                            AsyncImage(url: URL(string: user.fields.profileImage)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 41, height: 41)
                                    .clipShape(Circle())
                                    
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 41, height: 41)
                            .background(Color.white.opacity(0.21))
                            .clipShape(Circle())
                            

                            
                        }else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 41, height: 41)
                                
                        }
                    })
                    
                        
                }
                
//                ToolbarItem(placement: .principal){
//                    
//                    HStack {
//                       TextField("Search for movies, actors...", text: $movie)
//                           .padding(8)
//                           .padding(.horizontal, 24)
//                           .background(Color.white.opacity(0.2))
//                           .cornerRadius(8)
//                           .overlay(
//                               HStack {
//                                   Image(systemName: "magnifyingglass")
//                                       .foregroundColor(.gray)
//                                       .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                                       .padding(.leading, 8)
//                               }
//                           )
//                       
//                       if !movie.isEmpty {
//                           Button(action: {
//                               movie = "" // Clear the search query
//                           }) {
//                               Image(systemName: "xmark.circle.fill")
//                                   .foregroundColor(.gray)
//                                   .padding(.trailing, 8)
//                           }
//                       }
//                   }
//
//                }
                
                
                
            } // end toolbar
            
            
            
            
            
        } // end navgation
            
        
       
        
        
    }
}

#Preview {
    Home()
        .environmentObject(movieViewModel())
}



//                   .padding(.horizontal, 8)
//                   .frame(height: 36)
//                    .searchable(text: $movie,placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for movies, actors...") {
//                        // Suggestion items can be added here
//                        Text("Action").searchCompletion("Action")
//                        Text("Drama").searchCompletion("Drama")
//                        Text("Comedy").searchCompletion("Comedy")
//                    }
