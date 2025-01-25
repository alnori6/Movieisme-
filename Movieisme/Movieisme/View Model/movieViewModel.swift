//
//  movieViewModel.swift
//  Movieisme
//
//  Created by Noori on 18/01/2025.
//

import SwiftUI
import Combine

class movieViewModel: ObservableObject {
    
    // Published arrays to store the fetched data
    @Published var movies: [MoviesRecord] = []
    @Published var actors: [DirecrtorsRecord] = []
    @Published var reviews: [ReviewsRecord] = []
    
    @Published var users: [UsersRecord] = []

    // If you want directors or movieActors as well:
    @Published var directors: [DirecrtorsRecord] = []
    @Published var movieActors: [MovieActorsRecord] = []

    // We can keep an errorMessage to display in the UI
    @Published var errorMessage: String?
    
    @Published var isLoading = false

    private let service = APIService()
    
    //MARK: - calculations for the ratings
    // Converts a rating out of 10 into a 0–5 scale as a Double.
    // E.g. 9.0 becomes 4.5
    func convertRatingOutOfTenToFive(_ ratingOutOfTen: Double) -> Double {
        return ratingOutOfTen / 2.0
    }

    
    //MARK: - filter the movies
    
//    var dramaMovies: [MoviesRecord] {
//            movies.filter { $0.fields.genre.contains("Drama") }
//        }
    
//    var comedyMovies: [MoviesRecord] {
//            movies.filter { $0.fields.genre.contains("Comedy") }
//        }
    
    var heighRatedMovies: [MoviesRecord] {
        let heigh = ["Top Gun", "Tickets to Paradise", "Nothing is Impossible", "Causeway", "Raymond and Ray", "The Women King", "Shotgun Wedding"]
        
        return movies.filter { heigh.contains($0.fields.name) }
    }
    
    var dramaMovies: [MoviesRecord] {
        let drama = ["The Shawshank Redemption", "A Star Is Born"]
        
        return movies.filter { drama.contains($0.fields.name) }
//        movies.filter { $0.fields.genre.contains("Drama") }
    }
    
    var comedyMovies: [MoviesRecord] {
        let comedy = ["World's Greatest Dad", "House Party"]
        
        return movies.filter { comedy.contains($0.fields.name) }
    }
    
    
    
    // MARK: - Fetch Methods

    func loadMovies() {
            isLoading = true
            errorMessage = nil
            
           service.fetchMovies { [weak self] result in
               switch result {
               case .success(let moviesContainer):
                   // moviesContainer is a `Movies` object. Let's store the array of records.
                   self?.isLoading = false
                   self?.movies = moviesContainer.records
               case .failure(let error):
                   self?.errorMessage = "Failed to load movies: \(error.localizedDescription)"
               }
           }
        }
    

    func loadActors() {
       service.fetchActors { [weak self] result in
           switch result {
           case .success(let actorsContainer):
               // actorsContainer is `Actors`. The optional `records` is `[DirecrtorsRecord]?`.
               // We'll store it if it's not nil.
               self?.actors = actorsContainer.records ?? []
           case .failure(let error):
               self?.errorMessage = "Failed to load actors: \(error.localizedDescription)"
           }
       }
    }

    func loadReviews() {
       service.fetchReviews { [weak self] result in
           switch result {
           case .success(let reviewsContainer):
               self?.reviews = reviewsContainer.records
           case .failure(let error):
               self?.errorMessage = "Failed to load reviews: \(error.localizedDescription)"
           }
       }
    }

    func loadUsers() {
       service.fetchUsers { [weak self] result in
           switch result {
           case .success(let usersContainer):
               self?.users = usersContainer.records
           case .failure(let error):
               self?.errorMessage = "Failed to load users: \(error.localizedDescription)"
           }
       }
    }

    func loadDirectors() {
       service.fetchDirectors { [weak self] result in
           switch result {
           case .success(let directorsContainer):
               // Direcrtors has `records: [DirecrtorsRecord]`
               self?.directors = directorsContainer.records
           case .failure(let error):
               self?.errorMessage = "Failed to load directors: \(error.localizedDescription)"
           }
       }
    }

    func loadMovieActors() {
       service.fetchMovieActors { [weak self] result in
           switch result {
           case .success(let movieActorsContainer):
               self?.movieActors = movieActorsContainer.records
           case .failure(let error):
               self?.errorMessage = "Failed to load movie actors: \(error.localizedDescription)"
           }
       }

    }
    
    
    
    
    // MARK: - (Optional) One method to load all data at once
        func loadAllData() {
            loadMovies()
            loadActors()
            loadUsers()
            loadDirectors()
//            loadReviews()
            loadMovieActors()
        }
    
    
}

