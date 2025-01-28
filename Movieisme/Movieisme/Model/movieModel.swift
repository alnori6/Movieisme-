//
//  movieViewModel.swift
//  Movieisme
//
//  Created by Noori on 18/01/2025.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:

//   let reviews = try? JSONDecoder().decode(Reviews.self, from: jsonData)
//   let direcrtors = try? JSONDecoder().decode(Direcrtors.self, from: jsonData)
//   let users = try? JSONDecoder().decode(Users.self, from: jsonData)
//   let actors = try? JSONDecoder().decode(Actors.self, from: jsonData)
//   let movieActors = try? JSONDecoder().decode(MovieActors.self, from: jsonData)
//   let movies = try? JSONDecoder().decode(Movies.self, from: jsonData)

//https://api.airtable.com/v0/appsfcB6YESLj4NCN/movie_directors?filterByFormula=movie_id="5c8b046a-3c22-46c7-8472-fcf8707c7af6"



import Foundation

// MARK: - Reviews
struct Reviews: Codable {
    let records: [ReviewsRecord]
}

// MARK: - ReviewsRecord
struct ReviewsRecord: Codable, Identifiable {
    let id, createdTime: String
    let fields: PurpleFields
}

// MARK: - PurpleFields
struct PurpleFields: Codable {
    let reviewText: String
    let rate: Int
//    let movieID: ID
    let movieID: String
    let userID: String

    enum CodingKeys: String, CodingKey {
        case reviewText = "review_text"
        case rate
        case movieID = "movie_id"
        case userID = "user_id"
    }
}

//enum ID: String, Codable {
//    case recD3RGUbacFapkel = "recD3RGUbacFapkel"
//    case reca1OIICB4R3HVgw = "reca1oIIcB4R3HVgw"
//    case recsMLdAxVeCETUOO = "recsMLdAxVeCETUOo"
//}

// MARK: - Direcrtors
struct Direcrtors: Codable {
    let records: [DirecrtorsRecord]
}

// MARK: - DirecrtorsRecord
struct DirecrtorsRecord: Codable , Identifiable{
    let id, createdTime: String
    let fields: FluffyFields
}

// MARK: - FluffyFields
struct FluffyFields: Codable {
    let name: String
    let image: String
}



// MARK: - Movies Direcrtors
struct MovieDirectors:Codable{
    let records: [MovieDirectorsRecord]
}

// MARK: - MovieDirectorsRecord
struct MovieDirectorsRecord:Codable, Identifiable{
    let id, createdTime: String
    let fields: MovieDirectorsFields
}

// MARK: - MovieDirectorsFields
struct MovieDirectorsFields: Codable {
    let directorID: String
    let movieID: String
    
    enum CodingKeys: String, CodingKey {
        case directorID = "director_id"
        case movieID = "movie_id"
    }
}




// MARK: - Actors

// MARK: - MovieActors
struct MovieActors: Codable {
    let records: [MovieActorsRecord]
}

// MARK: - MovieActorsRecord
struct MovieActorsRecord: Codable, Identifiable {
    let id, createdTime: String
    let fields: MovieActorsFields
}

// MARK: - MovieActorsFields
struct MovieActorsFields: Codable {
    let actorID: String
    let movieID: String

    enum CodingKeys: String, CodingKey {
        case actorID = "actor_id"
        case movieID = "movie_id"
    }
}

// MARK: - Actors
struct Actors: Codable {
    let records: [ActorsRecord]
}

// MARK: - ActorsRecord
struct ActorsRecord: Codable, Identifiable {
    let id, createdTime: String
    let fields: ActorFields
}

// MARK: - ActorFields
struct ActorFields: Codable {
    let name: String
    let image: String
}


//struct Actors: Codable {
//    let records: [DirecrtorsRecord]?
//    let name: String?
//    let founded: Int?
//    let members: [String]?
//}
//
//// MARK: - MovieActors
//struct MovieActors: Codable {
//    let records: [MovieActorsRecord]
//}
//
//// MARK: - MovieActorsRecord
//struct MovieActorsRecord: Codable, Identifiable {
//    let id, createdTime: String
//    let fields: StickyFields
//}
//
//// MARK: - StickyFields
//struct StickyFields: Codable {
//    let actorID: String
////    let movieID: ID
//    let movieID: String
//
//    enum CodingKeys: String, CodingKey {
//        case actorID = "actor_id"
//        case movieID = "movie_id"
//    }
//}

// MARK: - Movies
struct Movies: Codable {
    let records: [MoviesRecord]
}

// MARK: - MoviesRecord
struct MoviesRecord: Codable, Identifiable {
//    let id: ID
    let id: String
    let createdTime: String
    let fields: IndigoFields
}

// MARK: - IndigoFields
struct IndigoFields: Codable {
    let name, rating: String
    let genre: [String]
    let poster: String
    let language: [String]
    let imDBRating: Double
    let runtime, story: String

    enum CodingKeys: String, CodingKey {
        case name, rating, genre, poster, language
        case imDBRating = "IMDb_rating"
        case runtime, story
    }
}


// MARK: - Users
struct Users: Codable {
    let records: [UsersRecord]
}

// MARK: - UsersRecord
struct UsersRecord: Codable , Identifiable{
    let id, createdTime: String
    var fields: TentacledFields
}

// MARK: - TentacledFields
struct TentacledFields: Codable {
    var name, password, email: String
    let profileImage: String
    var savedMovies: [MoviesRecord] = [] // to store saved movies for each user

    enum CodingKeys: String, CodingKey {
        case name, password, email
        case profileImage = "profile_image"
    }
}


