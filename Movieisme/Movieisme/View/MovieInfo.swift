//
//  MovieInfo.swift
//  Movieisme
//
//  Created by Noori on 28/01/2025.
//

import SwiftUI

struct MovieInfo: View {
    
    @EnvironmentObject private var movieVM : movieViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let movie: MoviesRecord
    //    @State var director: DirecrtorsRecord
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                
                VStack(){
                    
                    ZStack() {
                        // Movie Poster
                        AsyncImage(url: URL(string: movie.fields.poster)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView("Loading...")
                        }
                        
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0)]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        
                    }
                    .padding(.top, -60)
                    .frame(height: 350)
                    
                    
                    
                    Text(movie.fields.name)
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Spacer().frame(height: 40)
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(100),spacing: 70),
                        GridItem(.fixed(100),spacing: 70)
                    ],alignment: .leading,  spacing: 32){
                        
                        VStack(spacing: 8){
                            Text("Duration")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(movie.fields.runtime)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        
                        VStack(spacing: 8){
                            Text("Language")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(movie.fields.language.joined(separator: ", "))")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        
                        VStack(spacing: 8){
                            Text("Genre")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(movie.fields.genre.joined(separator: ", "))")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        VStack(spacing: 8){
                            Text("Age")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("+15")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    //MARK: - story
                    
                    Spacer().frame(height: 32)
                    
                    VStack(spacing: 8){
                        Text("Story")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(movie.fields.story)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("Dark4"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    .padding(.trailing, 16)
                    
                    
                    //MARK: - rating
                    
                    Spacer().frame(height: 32)
                    
                    VStack(spacing: 8){
                        Text("IMDb Rating")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(movie.fields.imDBRating, specifier: "%.1f") / 10")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("Dark4"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    
                    Divider()
                        .background(Color("Dark3"))
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    
                    // MARK: - directors
                    
                    Text("Director")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                        .padding(.horizontal)
                    
                    HStack(spacing: 8){
                        VStack(spacing: 8){
                            
                            if let director = movieVM.getDirectorForMovie(movieID: movie.id) {
                                
                                AsyncImage(url: URL(string: director.fields.image)) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .offset(x: -15, y: 0)
                                        .frame(width: 76, height: 76)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                
                                Text(director.fields.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("Dark4"))
                                
                                
                            } else {
                                Text("Director not available")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .background(Color("Dark3"))
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    // MARK: - Actors getActorsForMovie
                    Text("Stars")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                        .padding(.horizontal)
                    
                    
                    
                    
                    let actors = movieVM.getActorsForMovie(movieID: movie.id)
                    if actors.isEmpty {
                        Text("Actors not available")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                    } else {
                        HStack(spacing: 16) {
                        ForEach(actors, id: \.id) { actor in
                                VStack(spacing: 8){
                                    // Actor Image
                                    AsyncImage(url: URL(string: actor.fields.image)) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 76, height: 76)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    // Actor Name
                                    Text(actor.fields.name)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color("Dark4"))
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                    }
                    
                    
                    
                    
                    Spacer().frame(height: 40)
                    
                    Divider()
                        .background(Color("Dark3"))
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    
                    
                    Spacer().frame(height: 24)
                    
                    
                    // MARK: - Actors getActorsForMovie
                    let ratingDouble = movieVM.convertRatingOutOfTenToFive(movie.fields.imDBRating)
                    
                    Text("Rating  & Reviews")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                        .padding(.horizontal)

                    Text("\(ratingDouble, specifier: "%.1f")")
                        .font(.system(size: 39, weight: .semibold))
                        .foregroundColor(Color("Dark4"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)
                        .padding(.horizontal)
                    
                    Text("out of 5")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color("Dark4"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,5)
                        .padding(.horizontal)
                    
                    //MARK: - Ratings from other watchers
                    
                    
                    
                    
                    
                    
                    
                    
                    Spacer().frame(height: 40)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }// end scroll view
            .onAppear(){
                movieVM.loadDirectors()
                movieVM.loadMovieDirectors()
                movieVM.loadActors()
                movieVM.loadMovieActors()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(){
                ToolbarItem(placement: .topBarLeading){
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 18)
                            .bold()
                            .foregroundColor(.accent)
                            .frame(width: 32, height: 32)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        
                    }){
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 14, height: 20)
                            .bold()
                            .foregroundColor(.accent)
                            .frame(width: 32, height: 32)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        movieVM.saveMovie(movie: movie)
                    }) {
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .frame(width: 12, height: 18)
                            .foregroundColor(.accent)
                            .frame(width: 32, height: 32)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                        
                    }
                }
            }
            .toolbarBackgroundVisibility(.automatic, for: .navigationBar)
            
        }// end navigationstack
    }
}

#Preview {
    //    MovieInfo()
    //        .environmentObject(movieViewModel())
    
    MovieInfo(
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
        
        //      director: DirecrtorsRecord(
        //        id: "1",
        //        createdTime: "0000-00-00T00:00:00Z",
        //        fields: FluffyFields(
        //            name: "Frank Darabont",
        //            image: "https://spaces.filmstories.co.uk/uploads/2024/09/Frank-Darabont.jpg"
        //        )
        //
        //      )
    ).environmentObject(movieViewModel())
    
}
