//
//  Home.swift
//  Movieisme
//
//  Created by Noori on 18/01/2025.
//

import SwiftUI

struct Home: View {
    @State var movie: String = ""
    
//    @StateObject private var movieVM = movieViewModel()
    @EnvironmentObject private var movieVM : movieViewModel
    @State private var selectedPage = 0 // To track the current page
    @State private var selectedPageDrama = 0 // To track the current page
//    @EnvironmentObject private var movieVM : movieViewModel
    
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
                
                VStack(alignment: .leading) {
                        Spacer().frame(height: 16)
                    
                    Text("High Rated")
                        .font(.system(size: 22, weight: .semibold, design: .default))
                        .padding(.leading, 16)
                        
                    Spacer().frame(height: 16)
                    
                    // MARK: - the tabview for the movies whole
                    TabView(selection: $selectedPage) {
                        ForEach(movieVM.movies.indices, id: \.self) { index in
                            MovieCardView(movie: movieVM.movies[index])
                                .tag(index)
//                                .environmentObject(movieVM)// Use the MovieCard component here
                        }
                        
                    }
                    .onAppear {
                        movieVM.loadMovies()
                    }
                    .frame(width: 366, height: 424)
                   .tabViewStyle(.page(indexDisplayMode: .never))
                   .containerRelativeFrame(Axis.Set.horizontal, alignment: .center)
                   
                    
                    // Custom page indicator
                    HStack(spacing: 8) {
                        Spacer()
                        ForEach(movieVM.movies.indices, id: \.self) { index in
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
                        
                        Text("Show more")
                            .foregroundColor(.accent)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding()
                    
                    TabView(selection: $selectedPageDrama) {
                        ForEach(movieVM.dramaMovies.indices, id: \.self) { index in
                            MovieCardView(movie: movieVM.dramaMovies[index])
                                .tag(index)
                        }
                    }
                    .frame(width: 355, height: 424)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .containerRelativeFrame(Axis.Set.horizontal, alignment: .center)
                    
                     
                     // Custom page indicator
                     HStack(spacing: 8) {
                         Spacer()
                         ForEach(movieVM.dramaMovies.indices, id: \.self) { index in
                             Circle()
                                 .frame(width: index == selectedPageDrama ? 12 : 8, height: index == selectedPageDrama ? 12 : 8)
                                 .foregroundColor(index == selectedPageDrama ? .white : .gray)
                                 .opacity(index == selectedPageDrama ? 1 : 0.6)
                         }
                         Spacer()
                     }
                     .padding(.top, 16)
                    
                    //MARK: - Comedy part
                    Spacer().frame(height: 40)
                    
                    HStack(){
                        Text(
                            movieVM.movies.contains { $0.fields.genre.contains("Comedy") }
                            ? "Comedy"
                            : "Comedy"
                        )
                        .font(.system(size: 22, weight: .semibold))
//                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        Text("Show more")
                            .foregroundColor(.accent)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding()
                    
                    
                    
                }// end of the big vstack
                .frame(maxWidth: .infinity, alignment: .leading)
                    
            } // end scroll view
            
            .background(Color.black)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Movies Center")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .padding(.bottom, 16)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("user1")
                        .resizable()
                        .frame(width: 41, height: 41)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                        
                }
                
                
            }
            .searchable(text: $movie, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for movies, actors...") {
                // Suggestion items can be added here
                Text("Action").searchCompletion("Action")
                Text("Drama").searchCompletion("Drama")
                Text("Comedy").searchCompletion("Comedy")
            }
            
            
            
            
        } // end navgation
            
        
       
        
        
    }
}

#Preview {
    Home()
        .environmentObject(movieViewModel())
}
