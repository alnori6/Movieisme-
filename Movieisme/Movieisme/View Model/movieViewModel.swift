//
//  movieViewModel.swift
//  Movieisme
//
//  Created by Noori on 18/01/2025.
//

import SwiftUI
import PhotosUI
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
        loadReviews() // Ensure reviews are loaded
        loadLoggedInUser() // Restore logged-in user from UserDefaults
    }
    
    
    //MARK: - calculations for the ratings
    // Converts a rating out of 10 into a 0–5 scale as a Double.
    // E.g. 9.0 becomes 4.5
    func convertRatingOutOfTenToFive(_ ratingOutOfTen: Double) -> Double {
        return ratingOutOfTen / 2.0
    }

    
    //MARK: - filter the movies
    
    var dramaMovies: [MoviesRecord] {
            movies.filter { $0.fields.genre.contains("Drama") }
        }
    
    var comedyMovies: [MoviesRecord] {
            movies.filter { $0.fields.genre.contains("Comedy") }
        }
    
    var ActionMovies: [MoviesRecord] {
        movies.filter { $0.fields.genre.contains("Action") }
    }
    
    var ThrillerMovies: [MoviesRecord] {
        movies.filter { $0.fields.genre.contains("Thriller") } 
    }
    
    var CrimeMovies: [MoviesRecord] {
        movies.filter { $0.fields.genre.contains("Crime") }
    }
    
    var heighRatedMovies: [MoviesRecord] {
        let heigh = ["Top Gun", "Tickets to Paradise", "Nothing is Impossible", "Causeway", "Raymond and Ray", "The Women King", "Shotgun Wedding"]
        
        return movies.filter { heigh.contains($0.fields.name) }
    }
    
//    var dramaMovies: [MoviesRecord] {
//        let drama = ["The Shawshank Redemption", "A Star Is Born"]
//        
//        return movies.filter { drama.contains($0.fields.name) }
////        movies.filter { $0.fields.genre.contains("Drama") }
//    }
////    
//    var comedyMovies: [MoviesRecord] {
//        let comedy = ["World's Greatest Dad", "House Party"]
//        
//        return movies.filter { comedy.contains($0.fields.name) }
//    }
    
    
    //=====================================================
    // MARK: - SEARCHING
    //=====================================================
    
    
    func searchMoviesActorsDirectors(query: String) -> [SearchResult] {
        guard !query.isEmpty else { return [] }

        var results: [SearchResult] = []
        
        // 🔎 Search in Movies
        let matchingMovies = movies.filter { $0.fields.name.localizedCaseInsensitiveContains(query) }
        results.append(contentsOf: matchingMovies.map { SearchResult(id: $0.id, type: .movie, name: $0.fields.name) })
        
        // 🔎 Search in Actors
        let matchingActors = actors.filter { $0.fields.name.localizedCaseInsensitiveContains(query) }
        results.append(contentsOf: matchingActors.map { SearchResult(id: $0.id, type: .actor, name: $0.fields.name) })
        
        // 🔎 Search in Directors
        let matchingDirectors = directors.filter { $0.fields.name.localizedCaseInsensitiveContains(query) }
        results.append(contentsOf: matchingDirectors.map { SearchResult(id: $0.id, type: .director, name: $0.fields.name) })
        
        return results
    }
    
    
    
    
    //=====================================================
    // MARK: - PHOTO PICKER
    //=====================================================
    
    // ✅ Photo Picker Support
       @Published var selectedImage: UIImage?
       @Published var photoPickerItem: PhotosPickerItem? {
           didSet { fetchSelectedImage() }
       }
    

    func fetchSelectedImage() {
        guard let photoPickerItem = photoPickerItem else { return }

        photoPickerItem.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        self.selectedImage = image
                        self.updateProfileImage(image: image) // ✅ Call API upload
                    }
                case .failure(let error):
                    print("❌ Failed to load image: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateProfileImage(image: UIImage) {
        guard let user = loggedInUser else { return }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Failed to convert image to Data")
            return
        }

        // ✅ Step 1: Upload Image
        service.uploadProfileImage(userID: user.id, imageData: imageData) { [weak self] result in
            switch result {
            case .success(let imageURL):
                DispatchQueue.main.async {
                    print("✅ Image Uploaded: \(imageURL)")

                    // ✅ Step 2: Update User Profile with Image URL
                    var updatedUser = user
                    updatedUser.fields.profileImage = imageURL

                    self?.service.updateUser(user: updatedUser) { updateResult in
                        switch updateResult {
                        case .success(let updatedUser):
                            self?.loggedInUser = updatedUser
                            self?.saveLoggedInUser()
                            print("✅ Profile Image Updated in API")
                        case .failure(let error):
                            print("❌ Failed to update user profile: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("❌ Image Upload Failed: \(error.localizedDescription)")
            }
        }
    }
    
    
//    func uploadProfileImage(userID: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
//        let boundary = UUID().uuidString
//        let url = URL(string: "https://your-api.com/upload")! // ✅ Replace with your actual API URL
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        // ✅ Construct the multipart form-data body
//        var body = Data()
//        
//        let filename = "profile.jpg"
//        let mimeType = "image/jpeg"
//
//        // 📌 Add image data
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"profileImage\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//        body.append(imageData)
//        body.append("\r\n".data(using: .utf8)!)
//
//        // 📌 Add closing boundary
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//
//        request.httpBody = body
//
//        // ✅ Perform Upload Request
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "Invalid Image Response", code: 0, userInfo: nil)))
//                return
//            }
//
//            // ✅ Parse response to get uploaded image URL
//            if let imageURL = String(data: data, encoding: .utf8) {
//                completion(.success(imageURL))
//            } else {
//                completion(.failure(NSError(domain: "Failed to parse image URL", code: 0, userInfo: nil)))
//            }
//        }.resume()
//    }
    
    func uploadProfileImage(userID: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.cloudinary.com/v1_1/YOUR_CLOUD_NAME/image/upload")! // ✅ Replace with your Cloudinary URL
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        let paramName = "file"
        let mimeType = "image/jpeg"
        
        // Add Cloudinary Upload Preset
        let uploadPreset = "YOUR_UPLOAD_PRESET"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        
        // Add Image Data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Perform Upload Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let secureURL = json["secure_url"] as? String {
                    completion(.success(secureURL)) // ✅ Image uploaded successfully, return URL
                } else {
                    completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
  
    
    
    //=====================================================
    // MARK: - LOADERS
    //=====================================================
    
    
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
    
    
    func loadActors() {
        service.fetchActors { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let actorsContainer):
                    self?.actors = actorsContainer.records
                    print("Successfully loaded actors: \(actorsContainer.records.count) records.")
                    print("===========================================\n")
                case .failure(let error):
                    self?.errorMessage = "Failed to load actors: \(error.localizedDescription)"
                    print("Error fetching actors: \(error.localizedDescription)")
                    print("===========================================\n")
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
    
    
    func loadReviews() {
       service.fetchReviews { [weak self] result in
           switch result {
           case .success(let reviewsContainer):
               self?.reviews = reviewsContainer.records
           case .failure(let error):
               self?.errorMessage = "Failed to load reviews: \(error.localizedDescription)"
               print("=====================\n")
           }
       }
    }

    
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

    
    
    
    //=====================================================
    //MARK: -  Fetch movie-director relationships
    //=====================================================
    
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
    
    
    
    
    //=====================================================
    //MARK: -  Fetch movie-Actors relationships
    //=====================================================
    
    //MARK: - checking the id for the Actor that is similar to the movie
    
    
    /// Retrieves the actors associated with a given movie.
    /// - Parameter movieID: The ID of the movie for which actors are being fetched.
    /// - Returns: An array of `ActorsRecord` objects representing the actors for the movie.
    func getActorsForMovie(movieID: String) -> [ActorsRecord] {
        guard !actors.isEmpty, !movieActors.isEmpty else {
            print("Actors or movieActors data is not loaded yet.")
            print("=====================\n")
            return []
        }
        
        // Step 1: Filter `movieActors` for records where the movieID matches.
        let movieActorRecords = movieActors.filter { $0.fields.movieID == movieID }
        
        // Step 2: Find and return the actors corresponding to the actorIDs in `movieActorRecords`.
        let associatedActors = movieActorRecords.compactMap { movieActorRecord in
            actors.first { $0.id == movieActorRecord.fields.actorID }
        }
        
        print("Actors for Movie \(movieID): \(associatedActors)")
        print("=====================\n")
        return associatedActors
    }
    

    
    

    
    
    
    
    //=====================================================
    // MARK: - reviews
    //=====================================================
    
    var isDataLoaded: Bool {
        !reviews.isEmpty && !users.isEmpty
    }
   
//    /// Retrieves the reviews associated with a given movie, including user information.
//    /// - Parameter movieID: The ID of the movie for which reviews are being fetched.
//    /// - Returns: An array of tuples containing the review and the corresponding user.
//    func getReviewsForMovie(movieID: String) -> [(review: ReviewsRecord, user: UsersRecord)] {
//        guard !reviews.isEmpty, !users.isEmpty else {
//            print("Reviews or users data are not loaded yet.")
//            print("=====================\n")
//            return []
//        }
//
//        // ✅ Step 1: Filter reviews for the given movie ID
//        let movieReviews = reviews.filter { $0.fields.movieID == movieID }
//
//        // ✅ Step 2: Map each review to its corresponding user
//        let associatedReviewsAndUsers = movieReviews.compactMap { review in
//            if let user = users.first(where: { $0.id == review.fields.userID }) {
//                return (review: review, user: user)
//            }
//            return nil
//        }
//
//        print("✅ Loaded \(associatedReviewsAndUsers.count) reviews for Movie ID: \(movieID)")
//        print("=====================\n")
//        return associatedReviewsAndUsers
//    }
    

    
    //connect the movieID from ReviewsRecord to the id of MoviesRecord,
    //you need to fetch reviews and find the corresponding movie from the list of movies using the movieID.
    func getMovieByID(movieID: String) -> MoviesRecord? {
        return movies.first { $0.id == movieID }
    }
    
    func getReviewsWithMovies() -> [(review: ReviewsRecord, movie: MoviesRecord?)] {
        return reviews.map { review in
            let relatedMovie = getMovieByID(movieID: review.fields.movieID) // 🔥 Fetch movie
            print(relatedMovie ?? "🥛🥛🥛🥛🥛🥛🥛 Movie not found 🥛🥛🥛🥛🥛🥛")
            return (review: review, movie: relatedMovie)
        }
    }
    
    
    // ✅ Step 1: Filter reviews for the given movie ID
    func getFilteredReviews(for movieID: String) -> [ReviewsRecord] {
        let filteredReviews = reviews.filter { $0.fields.movieID == movieID }
        print("✅ Found \(filteredReviews.count) reviews for Movie ID: \(movieID)")
        return filteredReviews
    }
    
   
    func getReviewsForMovie(movieID: String) -> [(review: ReviewsRecord, user: UsersRecord)] {
        // ✅ Ensure both reviews and users are loaded
        guard !reviews.isEmpty, !users.isEmpty else {
            print("❌ Reviews or users data are not loaded yet.")
            return []
        }

        // ✅ Step 1: Get the filtered reviews using the new function
        let movieReviews = getFilteredReviews(for: movieID)

        // ✅ Step 2: Map each review to its corresponding user
        let associatedReviewsAndUsers = movieReviews.compactMap { review in
            if let user = users.first(where: { $0.id == review.fields.userID }) {
                print("✅ Matched review '\(review.fields.reviewText)' with user: \(user.fields.name)")
                return (review: review, user: user)
            } else {
                print("❌ No user found for review: \(review.fields.reviewText)")
                return nil
            }
        }

        print("✅ Loaded \(associatedReviewsAndUsers.count) reviews with users")
        return associatedReviewsAndUsers
    }
    

    // ✅ Function to format ISO 8601 date string into "MMMM d, yyyy"
    func formatDate(from isoDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Exact format from JSON
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing

        if let date = dateFormatter.date(from: isoDate) {
            dateFormatter.dateFormat = "MMMM d, yyyy" // Convert to readable format
            return dateFormatter.string(from: date)
        } else {
            print("❌ Failed to parse date: \(isoDate)")
            return "Invalid Date"
        }
    }
    
    
    
    
    
    
    
    //=====================================================
    //MARK: - users
    //=====================================================
    //MARK: - login
    
    @Published var loggedInUser: UsersRecord? // To store the logged-in user
    private let userDefaultsKey = "loggedInUser"
    
    /// Saves the logged-in user to UserDefaults.
        func saveLoggedInUser() {
            guard let loggedInUser = loggedInUser else { return }
            do {
                let encodedUser = try JSONEncoder().encode(loggedInUser)
                UserDefaults.standard.set(encodedUser, forKey: userDefaultsKey)
                print("✅ Successfully saved user session")
            } catch {
                print("❌ Failed to save logged-in user: \(error)")
            }
        }

        /// Loads the logged-in user from UserDefaults.
        func loadLoggedInUser() {
            if let savedUserData = UserDefaults.standard.data(forKey: userDefaultsKey),
               let decodedUser = try? JSONDecoder().decode(UsersRecord.self, from: savedUserData) {
                loggedInUser = decodedUser
                loadSavedMovies() // ✅ Load saved movies for the user
            }
        }

        /// Logs out the user and removes their data.
        func logoutUser() {
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            loggedInUser = nil
            print("✅ User logged out")
        }

        // validation
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

        // ✅ Preserve Saved Movies before updating the user
        let savedMoviesBackup = loggedInUser.fields.savedMovies

        // Update the user's name
        loggedInUser.fields.name = "\(firstName) \(lastName)"

        // ✅ API Call to update user info
        service.updateUser(user: loggedInUser) { [weak self] result in
            switch result {
            case .success(var updatedUser):
                // ✅ Restore Saved Movies after update
                updatedUser.fields.savedMovies = savedMoviesBackup
                self?.loggedInUser = updatedUser

                // ✅ Update user in stored array
                if let index = self?.users.firstIndex(where: { $0.id == updatedUser.id }) {
                    self?.users[index] = updatedUser
                }

                self?.saveLoggedInUser()
                completion(true)
            case .failure(let error):
                print("❌ Failed to update user: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    
    
    //=====================================================
    // MARK: - saved movies for each user
    //=====================================================

    /// Generates a unique key for each user's saved movies.
       private func getSavedMoviesKey(for email: String) -> String {
           return "savedMovies_\(email.lowercased())"
       }

       /// Saves the logged-in user's saved movies to UserDefaults.
       private func saveSavedMovies() {
           guard let loggedInUser = loggedInUser else { return }
           let savedMoviesKey = getSavedMoviesKey(for: loggedInUser.fields.email)

           do {
               let encodedMovies = try JSONEncoder().encode(loggedInUser.fields.savedMovies)
               UserDefaults.standard.set(encodedMovies, forKey: savedMoviesKey)
               print("✅ Successfully saved movies for \(loggedInUser.fields.email)")
           } catch {
               print("❌ Failed to save saved movies: \(error)")
           }
       }

   /// Loads the logged-in user's saved movies from UserDefaults.
   private func loadSavedMovies() {
       guard let loggedInUser = loggedInUser else { return }
       let savedMoviesKey = getSavedMoviesKey(for: loggedInUser.fields.email)

       if let savedMoviesData = UserDefaults.standard.data(forKey: savedMoviesKey) {
           do {
               let savedMovies = try JSONDecoder().decode([MoviesRecord].self, from: savedMoviesData)
               self.loggedInUser?.fields.savedMovies = savedMovies
               print("✅ Loaded \(savedMovies.count) saved movies for \(loggedInUser.fields.email)")
           } catch {
               print("❌ Failed to load saved movies: \(error)")
           }
       }
   }

   /// Returns the logged-in user's saved movies.
   func getSavedMovies() -> [MoviesRecord] {
       return loggedInUser?.fields.savedMovies ?? []
   }

   /// Adds a movie to the saved list for the logged-in user.
   func saveMovie(movie: MoviesRecord) {
       guard var loggedInUser = loggedInUser else { return }

       if !loggedInUser.fields.savedMovies.contains(where: { $0.id == movie.id }) {
           loggedInUser.fields.savedMovies.append(movie)
           self.loggedInUser = loggedInUser
           saveSavedMovies() // ✅ Persist to UserDefaults
       }
   }

    
    // for the condition in the movieinfo
    func isMovieSaved(movie: MoviesRecord) -> Bool {
        return loggedInUser?.fields.savedMovies.contains(where: { $0.id == movie.id }) ?? false
    }
    
    
   /// Removes a movie from the saved list for the logged-in user.
   func removeSavedMovie(movie: MoviesRecord) {
       guard var loggedInUser = loggedInUser else { return }

       loggedInUser.fields.savedMovies.removeAll { $0.id == movie.id }
       self.loggedInUser = loggedInUser
       saveSavedMovies() // ✅ Persist to UserDefaults
   }

    

    
    
    
    
    
    

    
    
    
    
    
    // MARK: - (Optional) One method to load all data at once
        func loadAllData() {
            loadLoggedInUser()
            loadMovies()
            loadUsers()
            loadDirectors()
            loadReviews()
            loadActors()
            loadMovieActors()
            
           
        }
    
    
}

