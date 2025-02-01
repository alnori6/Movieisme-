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
    
    @State var showSheet: Bool = false
    
    let movie: MoviesRecord
    //    @State var director: DirecrtorsRecord
    
    var body: some View {
        
        NavigationStack {
            
            
            ScrollView {
                
                
                VStack(alignment: .leading){
                
                    ZStack() {
                        // Movie Poster
                        AsyncImage(url: URL(string: movie.fields.poster)) { image in
                            image.resizable()
                                .scaledToFill()
                                .clipped(antialiased: true)
                                .padding(.top, -80)
                                .frame(maxWidth: 390)
                        } placeholder: {
                            ProgressView("Loading...")
                                .frame(width: 390, height: 444)
                        }
                        
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(1.1), Color.black.opacity(0)]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        
                    }
                    .frame(height: 444)
                    
                    // MARK: - the movie details starts here
                    
                    Text(movie.fields.name)
                        .font(.system(size: 28, weight: .bold))
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Spacer().frame(height: 40)
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(100),spacing: 70),
                        GridItem(.fixed(100),spacing: 70)
                    ],alignment: .leading,  spacing: 32){
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Duration")
                                .font(.system(size: 18, weight: .semibold))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(movie.fields.runtime)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Language")
                                .font(.system(size: 18, weight: .semibold))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(movie.fields.language.joined(separator: ", "))")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Genre")
                                .font(.system(size: 18, weight: .semibold))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(movie.fields.genre.joined(separator: ", "))")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Age")
                                .font(.system(size: 18, weight: .semibold))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("+15")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("Dark4"))
//                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    //MARK: - story
                    
                    Spacer().frame(height: 32)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Story")
                            .font(.system(size: 18, weight: .semibold))
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(movie.fields.story)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("Dark4"))
//                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)

                    
                    
                    //MARK: - rating
                    
                    Spacer().frame(height: 32)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("IMDb Rating")
                            .font(.system(size: 18, weight: .semibold))
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(movie.fields.imDBRating, specifier: "%.1f") / 10")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("Dark4"))
//                            .frame(maxWidth: .infinity, alignment: .leading)
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
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                        .padding(.horizontal)
                    
                    HStack(spacing: 8){
                        VStack(alignment: .leading, spacing: 8){
                            
                            if let director = movieVM.getDirectorForMovie(movieID: movie.id) {
                                
                                AsyncImage(url: URL(string: director.fields.image)) { image in
                                    image.resizable()
                                        .scaledToFill()
//                                        .offset(x: -15, y: 0)
                                        .frame(width: 76, height: 76)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(.horizontal)
                                
                                Text(director.fields.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("Dark4"))
                                
                                
                            } else {
                                Text("Director not available")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.gray)
//                                    .padding(.horizontal)
                            }
                            
                        }
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
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                        .padding(.horizontal)
                    
                    
                    
                    let actors = movieVM.getActorsForMovie(movieID: movie.id)
                    if actors.isEmpty {
                        Text("Actors not available")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
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
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                        }
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
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                        .padding(.horizontal)

                    Text("\(ratingDouble, specifier: "%.1f")")
                        .font(.system(size: 39, weight: .semibold))
                        .foregroundColor(Color("Dark4"))
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)
                        .padding(.horizontal)
                    
                    Text("out of 5")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color("Dark4"))
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,5)
                        .padding(.horizontal)
                    
                    //MARK: - Ratings from other watchers
                    
                    Spacer().frame(height: 32)
                    
                    
                    //MARK: - adding review ??
                    
                    Button(action: {
                        showSheet.toggle()
                    }){
                        Text("Add Review")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.bottom, 16)
                            .padding(.horizontal)
                            .foregroundColor(.accent)
                    }.sheet(isPresented: $showSheet) {
                        AddReviews(movie: movie)
                            .presentationDetents([.large])
                            .environmentObject(movieVM)
                    }
                    
                    let filteredReviews = movieVM.getReviewsForMovie(movieID: movie.id)

                    if filteredReviews.isEmpty {
                        Text("No reviews available.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredReviews, id: \.review.id) { reviewUser in
                                    ReviewsCard(movie: movie)
                                        .environmentObject(movieVM)
                                }
                            }
                        }
                    }
//                    
//                    

                    
                    
                    
                    Spacer().frame(height: 40)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }// end scroll view
            .onAppear(){
                print("🔄 Loading data...")
                movieVM.loadUsers()
                movieVM.loadDirectors()
                movieVM.loadMovieDirectors()
                movieVM.loadActors()
                movieVM.loadMovieActors()
                movieVM.loadReviews()
                movieVM.loadMovies()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        print("✅ Total Reviews Loaded: \(movieVM.reviews.count)")
                        print("✅ Total Users Loaded: \(movieVM.users.count)")
                    }
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
                    
                    ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui")!) {
                        
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
                            if movieVM.isMovieSaved(movie: movie) {
                                movieVM.removeSavedMovie(movie: movie) // 🔥 Remove if already saved
                            } else {
                                movieVM.saveMovie(movie: movie) // 🔥 Save if not saved
                            }
                        }) {
                            Image(systemName: movieVM.isMovieSaved(movie: movie) ? "bookmark.fill" : "bookmark") // ✅ Dynamic icon
                                .resizable()
                                .frame(width: 12, height: 18)
                                .foregroundColor(movieVM.isMovieSaved(movie: movie) ? .accent : .accent) // ✅ Change color
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
    
    MovieInfo(
        movie: MoviesRecord(
            id: "reca1oIIcB4R3HVgw",
            createdTime: "0000-00-00T00:00:00Z",
            fields: IndigoFields(
                name: "Top Gun",
                rating: "R",
                genre: ["Action"],
                poster: "https://i.imghippo.com/files/snS1877oNU.jpg",
                language: ["English"],
                imDBRating: 9.6,
                runtime: "2 hr 9 min",
                story: "Pete “Maverick” Mitchell is a hotshot Navy pilot whose skill is as legendary as his reckless streak. Sent to the elite TOPGUN program with his partner, “Goose,” Maverick competes against the best while wrestling with personal guilt and the shadow of his father’s mysterious past. A tragic loss forces him to overcome fear and self-doubt, pushing him to prove he’s more than just a daredevil. With everything on the line—his career, his confidence, and even a new romance—Maverick must rise above his own limits to claim his spot among the Navy’s top pilots."
                
            )
        )
        
    ).environmentObject(movieViewModel())
    
}
