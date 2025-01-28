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
    @Published var reviews: [ReviewsRecord] = []
    
    @Published var users: [UsersRecord] = []

    // If you want directors or movieActors as well:
    @Published var actors: [ActorsRecord] = []
    @Published var movieActors: [MovieActorsRecord] = []
    
    @Published var directors: [DirecrtorsRecord] = []
    @Published var movieDirectors: [MovieDirectorsRecord] = []
    

    // We can keep an errorMessage to display in the UI
    @Published var errorMessage: String?
    
    @Published var isLoading = false

    private let service = APIService()
    
    init() {
        loadUsers() // Ensure users are loaded first
        loadLoggedInUser() // Restore logged-in user from UserDefaults
    }
    
    
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
    
    
    //MARK: -  Fetch movie-director relationships
    func loadMovieDirectors() {
        service.fetchMovieDirectors { [weak self] result in
            switch result {
            case .success(let movieDirectorsContainer):
                self?.movieDirectors = movieDirectorsContainer.records
            case .failure(let error):
                self?.errorMessage = "Failed to load movie-directors: \(error.localizedDescription)"
            }
        }
    }
    
    //MARK: - checking the id for the director that is similar to the movie
    
    /// Retrieves the director associated with a given movie.
    /// - Parameter movieID: The ID of the movie for which the director is being retrieved.
    /// - Returns: A `DirecrtorsRecord` object representing the director of the movie, or `nil` if no matching director is found.
    func getDirectorForMovie(movieID: String) -> DirecrtorsRecord? {
        // Step 1: Find the `MovieDirectorsRecord` where the movieID matches the provided movieID.
            // `movieDirectors` contains the relationships between movies and directors.
            // Using `first(where:)` ensures we find the first record with the matching movieID.
        guard let movieDirectorRecord = movieDirectors.first(where: { $0.fields.movieID == movieID }) else {
            // If no relationship is found for the given movieID, return `nil`.
            return nil
        }
        // Step 2: Find the director whose ID matches the `directorID` from the found `MovieDirectorsRecord`.
            // The `directors` array contains all director records, and we're looking for the one with the matching ID.
        return directors.first(where: { $0.id == movieDirectorRecord.fields.directorID })
    }
    
    
    
    

    //MARK: -  Fetch movie-Actors relationships
    
    func loadActors() {
        service.fetchActors { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let actorsContainer):
                    self?.actors = actorsContainer.records
                    print("Successfully loaded actors: \(actorsContainer.records.count) records.")
                case .failure(let error):
                    self?.errorMessage = "Failed to load actors: \(error.localizedDescription)"
                    print("Error fetching actors: \(error.localizedDescription)")
                }
            }
        }
    }

    
    
    func loadMovieActors() {
        isLoading = true
        errorMessage = nil
        
        service.fetchMovieActors { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movieActorsContainer):
                    self?.movieActors = movieActorsContainer.records
                    print("Successfully loaded movie actors: \(movieActorsContainer.records.count) records.")
                case .failure(let error):
                    self?.errorMessage = "Failed to load movie actors: \(error.localizedDescription)"
                    print("Error fetching movie actors: \(error.localizedDescription)")
                }
            }
        }
    }
    
   


    //MARK: - checking the id for the Actor that is similar to the movie
    
//    func getActorsForMovie(movieID: String) -> ActorsRecord? {
//        guard let movieActorRecord = movieActors.first(where: { $0.fields.movieID == movieID }) else {
//            return nil
//        }
//        return actors.first(where: { $0.id == movieActorRecord.fields.actorID })
//    }
    
    /// Retrieves the actors associated with a given movie.
    /// - Parameter movieID: The ID of the movie for which actors are being fetched.
    /// - Returns: An array of `ActorsRecord` objects representing the actors for the movie.
    func getActorsForMovie(movieID: String) -> [ActorsRecord] {
        guard !actors.isEmpty, !movieActors.isEmpty else {
            print("Actors or movieActors data is not loaded yet.")
            return []
        }
        
        // Step 1: Filter `movieActors` for records where the movieID matches.
        let movieActorRecords = movieActors.filter { $0.fields.movieID == movieID }
        
        // Step 2: Find and return the actors corresponding to the actorIDs in `movieActorRecords`.
        let associatedActors = movieActorRecords.compactMap { movieActorRecord in
            actors.first { $0.id == movieActorRecord.fields.actorID }
        }
        
        print("Actors for Movie \(movieID): \(associatedActors)")
        return associatedActors
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

    //MARK: - users
    func loadUsers() {
       service.fetchUsers { [weak self] result in
           switch result {
           case .success(let usersContainer):
               self?.users = usersContainer.records
//               print(self?.users ?? "")
           case .failure(let error):
               self?.errorMessage = "Failed to load users: \(error.localizedDescription)"
           }
       }
    }
    
    // Retrieve the logged-in user from UserDefaults
    func loadLoggedInUser() {
        let email = UserDefaults.standard.string(forKey: "loggedInUserEmail")
        if let email = email {
            loggedInUser = users.first(where: { $0.fields.email.lowercased() == email.lowercased() })
        }
    }
    
    //MARK: - login
    
    @Published var loggedInUser: UsersRecord? // To store the logged-in user
    
    func saveLoggedInUser() {
        guard let loggedInUser = loggedInUser else { return }
        UserDefaults.standard.set(loggedInUser.fields.email, forKey: "loggedInUserEmail")
    }
    
    // Clear logged-in user from UserDefaults
    func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
        loggedInUser = nil
    }
    
    func validateUser(email: String, password: String) -> Bool {
        // Ensure users array is loaded
        guard !users.isEmpty else {
            print("Users not loaded.")
            return false
        }

        // Match email and password with records
        if let user = users.first(where: { $0.fields.email.lowercased() == email.lowercased() && $0.fields.password == password }) {
            loggedInUser = user // Store the logged-in user
            saveLoggedInUser()  // Save logged-in user to UserDefaults
            return true
        } else {
            return false
        }
    }
    
    
    
    //MARK: - update the user name
    

    func updateUserName(firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
        guard var loggedInUser = loggedInUser else {
            completion(false)
            return
        }
        
        // Update the user's name
        loggedInUser.fields.name = "\(firstName) \(lastName)"
        
        // Call the API to update the user
        service.updateUser(user: loggedInUser) { [weak self] result in
            switch result {
            case .success(let updatedUser):
                // Update the logged-in user in the ViewModel
                self?.loggedInUser = updatedUser
                // Update the user in the users array
                if let index = self?.users.firstIndex(where: { $0.id == updatedUser.id }) {
                    self?.users[index] = updatedUser
                }
                completion(true)
            case .failure(let error):
                print("Failed to update user: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    
    // MARK: - saved movies for each user

    // Add a movie to the saved list for the logged-in user
    func saveMovie(movie: MoviesRecord) {
        guard var loggedInUser = loggedInUser else { return }
        
        // Copy fields to modify
        var fields = loggedInUser.fields
        
        if !fields.savedMovies.contains(where: { $0.id == movie.id }) {
            fields.savedMovies.append(movie)
            
            // Update logged-in user's fields
            loggedInUser.fields = fields
            updateUser(loggedInUser)
        }
    }

    // Remove a movie from the saved list
    func removeSavedMovie(movie: MoviesRecord) {
        guard var loggedInUser = loggedInUser else { return }
        
        // Copy fields to modify
        var fields = loggedInUser.fields
        
        fields.savedMovies.removeAll(where: { $0.id == movie.id })
        
        // Update logged-in user's fields
        loggedInUser.fields = fields
        updateUser(loggedInUser)
    }

    // Fetch the saved movies for the logged-in user
    func getSavedMovies() -> [MoviesRecord] {
        loggedInUser?.fields.savedMovies ?? []
    }

    // Update the user in the users array
    private func updateUser(_ user: UsersRecord) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
            loggedInUser = user
        }
    }

    
    
    
    
    
    // MARK: - directors
    
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

    
    
    
    
    
    // MARK: - (Optional) One method to load all data at once
        func loadAllData() {
            loadMovies()
            loadUsers()
            loadDirectors()
            loadReviews()
            loadActors()
            loadMovieActors()
        }
    
    
}

