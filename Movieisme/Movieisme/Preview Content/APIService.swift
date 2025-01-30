//
//  APIService.swift
//  Movieisme
//
//  Created by Noori on 19/01/2025.
//

import Foundation

class APIService {
    // MARK: - 1) Base URL and Endpoints

     // Your Airtable base URL (notice we have placeholders for each table name).
     // For example: "https://api.airtable.com/v0/appsfcB6YESLj4NCN"
     // We'll concatenate the endpoint path for each resource (movies, actors, etc.) later.
     private let baseURLString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN"
     
     // MARK: - 2) API Key / Token
     // This is from your JSON: "Bearer pat7E88yW3dgzlY61.2b7d0..."
     // You do NOT want to hardcode secrets in production code, but for simplicity:
     private let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"
    
     
     // MARK: - 3) Public Fetch Functions
    
//    func fetchProducts() async throws -> [Movies]{
//        let url = URL(string: "\(baseURLString)/movies")!
//        let request = URLRequest (url: url)
//        let (data, _) = try await URLSession.shared.data(for: request)
//        let products = try JSONDecoder().decode( [Movies].self, from: data)
//        print (products)
//        return products
//    }
    
    
     /// Fetch all movies
     func fetchMovies(completion: @escaping (Result<Movies, Error>) -> Void) {
         // Build the full URL: base + "/movies"
         guard let url = URL(string: "\(baseURLString)/movies") else {
             completion(.failure(URLSessionError.invalidURL))
             return
         }
         
         // Then call our generic fetch method with decodeType: `Movies`
         fetchData(from: url, decodeType: Movies.self, completion: completion)
     }
    
    
    
    /// Fetch all directors
    func fetchDirectors(completion: @escaping (Result<Direcrtors, Error>) -> Void) {
        guard let url = URL(string: "\(baseURLString)/directors") else {
            completion(.failure(URLSessionError.invalidURL))
            return
        }
        
        fetchData(from: url, decodeType: Direcrtors.self, completion: completion)
    }
    
    
    
    func fetchMovieDirectors(completion: @escaping (Result<MovieDirectors, Error>) -> Void) {
        // Build the full URL: base + "/"
        guard let url = URL(string: "\(baseURLString)/movie_directors") else {
            completion(.failure(URLSessionError.invalidURL))
            return
        }
        
        // Then call our generic fetch method with decodeType: ``
        fetchData(from: url, decodeType: MovieDirectors.self, completion: completion)
    }
     
    
    
    
    
    
     /// Fetch all actors
     func fetchActors(completion: @escaping (Result<Actors, Error>) -> Void) {
         guard let url = URL(string: "\(baseURLString)/actors") else {
             completion(.failure(URLSessionError.invalidURL))
             return
         }
         
         fetchData(from: url, decodeType: Actors.self, completion: completion)
     }
    
    /// Fetch all movie-actors relationships
    func fetchMovieActors(completion: @escaping (Result<MovieActors, Error>) -> Void) {
        guard let url = URL(string: "\(baseURLString)/movie_actors") else {
            completion(.failure(URLSessionError.invalidURL))
            return
        }
        
        fetchData(from: url, decodeType: MovieActors.self, completion: completion)
    }
    
    
    
    
     
     /// Fetch all reviews
     func fetchReviews(completion: @escaping (Result<Reviews, Error>) -> Void) {
         guard let url = URL(string: "\(baseURLString)/reviews") else {
             completion(.failure(URLSessionError.invalidURL))
             return
         }
         
         fetchData(from: url, decodeType: Reviews.self, completion: completion)
     }
     
     //MARK: - Fetch all users
     func fetchUsers(completion: @escaping (Result<Users, Error>) -> Void) {
         guard let url = URL(string: "\(baseURLString)/users") else {
             completion(.failure(URLSessionError.invalidURL))
             return
         }
         
         fetchData(from: url, decodeType: Users.self, completion: completion)
     }
    
    
    
    
    // update the api users name after they save it
//    func updateUser(user: UsersRecord, completion: @escaping (Result<UsersRecord, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURLString)/users/\(user.id)") else {
//            completion(.failure(URLSessionError.invalidURL))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "fields": [
//                "name": user.fields.name,
//                "email": user.fields.email,
//                "password": user.fields.password,
//                "profile_image": user.fields.profileImage
//            ]
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse,
//               !(200...299).contains(httpResponse.statusCode) {
//                let statusError = NSError(
//                    domain: "",
//                    code: httpResponse.statusCode,
//                    userInfo: [NSLocalizedDescriptionKey : "HTTP \(httpResponse.statusCode)"]
//                )
//                DispatchQueue.main.async {
//                    completion(.failure(statusError))
//                }
//                return
//            }
//            
//            guard let data = data else {
//                let noDataError = NSError(
//                    domain: "",
//                    code: 0,
//                    userInfo: [NSLocalizedDescriptionKey : "No data in response"]
//                )
//                DispatchQueue.main.async {
//                    completion(.failure(noDataError))
//                }
//                return
//            }
//            
//            do {
//                let decodedObject = try JSONDecoder().decode(UsersRecord.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(decodedObject))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//        
//        task.resume()
//    }
    
    
    func updateUser(user: UsersRecord, completion: @escaping (Result<UsersRecord, Error>) -> Void) {
        guard let url = URL(string: "\(baseURLString)/users/\(user.id)") else {
            completion(.failure(URLSessionError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "fields": [
                "name": user.fields.name,
                "email": user.fields.email,
                "password": user.fields.password,
                "profile_image": user.fields.profileImage // ✅ Ensure this is included!
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let statusError = NSError(
                    domain: "",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey : "HTTP \(httpResponse.statusCode)"]
                )
                DispatchQueue.main.async {
                    completion(.failure(statusError))
                }
                return
            }

            guard let data = data else {
                let noDataError = NSError(
                    domain: "",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey : "No data in response"]
                )
                DispatchQueue.main.async {
                    completion(.failure(noDataError))
                }
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(UsersRecord.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
//    // MARK: - 4) Generic Fetch Method (✅ Debugging Added Here)
//        private func fetchData<T: Decodable>(from url: URL,
//                                             decodeType: T.Type,
//                                             completion: @escaping (Result<T, Error>) -> Void) {
//            var request = URLRequest(url: url)
//            request.addValue(apiKey, forHTTPHeaderField: "Authorization")
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                
//                // ✅ Step 1: Check for client-side error
//                if let error = error {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                    return
//                }
//                
//                // ✅ Step 2: Check HTTP status code
//                if let httpResponse = response as? HTTPURLResponse,
//                   !(200...299).contains(httpResponse.statusCode) {
//                    let statusError = NSError(
//                        domain: "",
//                        code: httpResponse.statusCode,
//                        userInfo: [NSLocalizedDescriptionKey : "HTTP \(httpResponse.statusCode)"]
//                    )
//                    DispatchQueue.main.async {
//                        completion(.failure(statusError))
//                    }
//                    return
//                }
//                
//                // ✅ Step 3: Verify we have data
//                guard let data = data else {
//                    let noDataError = NSError(
//                        domain: "",
//                        code: 0,
//                        userInfo: [NSLocalizedDescriptionKey : "No data in response"]
//                    )
//                    DispatchQueue.main.async {
//                        completion(.failure(noDataError))
//                    }
//                    return
//                }
//                
//                // ✅ Step 4: Debugging - Print Raw JSON Response Before Decoding
//                let jsonString = String(data: data, encoding: .utf8)
//                print("📜 Raw JSON Response: \(jsonString ?? "Invalid JSON")")
//
//                // ✅ Step 5: Attempt to decode the JSON into T
//                do {
//                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(decodedObject))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        print("❌ JSON Decoding Error: \(error)")
//                        completion(.failure(error))
//                    }
//                }
//            }
//            task.resume()
//        }
    
     
     
    
     
     // MARK: - 4) Generic Fetch Method
     
     /// Generic function to fetch and decode JSON from a URL
     private func fetchData<T: Decodable>(from url: URL,
                                          decodeType: T.Type,
                                          completion: @escaping (Result<T, Error>) -> Void) {
         // Build a request
         var request = URLRequest(url: url)
         
         // Add the required Authorization header: "Bearer <API_Key>"
         request.addValue(apiKey, forHTTPHeaderField: "Authorization")
         
         // Create a URLSession task
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             
             // 1) Check for client-side error
             if let error = error {
                 DispatchQueue.main.async {
                     completion(.failure(error))
                 }
                 return
             }
             
             // 2) Check HTTP status code
             if let httpResponse = response as? HTTPURLResponse,
                !(200...299).contains(httpResponse.statusCode) {
                 let statusError = NSError(
                     domain: "",
                     code: httpResponse.statusCode,
                     userInfo: [NSLocalizedDescriptionKey : "HTTP \(httpResponse.statusCode)"]
                 )
                 DispatchQueue.main.async {
                     completion(.failure(statusError))
                 }
                 return
             }
             
             // 3) Verify we have data
             guard let data = data else {
                 let noDataError = NSError(
                     domain: "",
                     code: 0,
                     userInfo: [NSLocalizedDescriptionKey : "No data in response"]
                 )
                 DispatchQueue.main.async {
                     completion(.failure(noDataError))
                 }
                 return
             }
             
             // 4) Attempt to decode the JSON into T
             do {
                 let decodedObject = try JSONDecoder().decode(T.self, from: data)
                 
                 // 5) Return success on main thread
                 DispatchQueue.main.async {
                     completion(.success(decodedObject))
                 }
                 
             } catch {
                 // If decoding fails, return that error
                 DispatchQueue.main.async {
                     completion(.failure(error))
                 }
             }
         }
         
         task.resume()
     }
    
    
    
    
    
    
    
    
    
    
    func uploadProfileImage(userID: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURLString)/uploadProfileImage") else {
            completion(.failure(URLSessionError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add Image Data
        let filename = "profile.jpg"
        let mimeType = "image/jpeg"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let imageURL = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid response"])))
                return
            }

            completion(.success(imageURL))
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
 }

 // MARK: - Helper Enum for URL Errors
 enum URLSessionError: Error {
     case invalidURL
 }
