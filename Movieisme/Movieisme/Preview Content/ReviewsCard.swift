//
//  ReviewsCard.swift
//  Movieisme
//
//  Created by Noori on 29/01/2025.
//

import SwiftUI

struct ReviewsCard: View {
    
    @EnvironmentObject var movieVM : movieViewModel
    let movie: MoviesRecord
    let maxRating: Int = 5
    
    var body: some View {
        let reviewsWithUsers = movieVM.getReviewsForMovie(movieID: movie.id)
        
        if reviewsWithUsers.isEmpty {
            Text("No reviews available.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // ✅ Loop through each review + user
                    ForEach(reviewsWithUsers, id: \.review.id) { reviewUser in
                        
                        let ratingDouble = movieVM.convertRatingOutOfTenToFive(reviewUser.review.fields.rate)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Spacer().frame(height: 4)
                            HStack(spacing: 8){
                                // ✅ User Profile Image
                                AsyncImage(url: URL(string: reviewUser.user.fields.profileImage)) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 38, height: 38)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 38, height: 38)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    // ✅ User Name
                                    Text(reviewUser.user.fields.name)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color.white)
                                    
                                    HStack(spacing: 0) {
                                        ForEach(1...maxRating, id: \.self) { index in
                                            Image(systemName: index <= Int(floor(ratingDouble)) ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 9, weight: .medium, design: .default))
                                        }
                                    }
                                }
                                Spacer()
                            }
                            
                            Spacer()
                            
                            // ✅ Review Text
                            Text(reviewUser.review.fields.reviewText)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(Color.white)
                                .lineLimit(4)
                            
                            Spacer()
                            
                            Text(movieVM.formatDate(from: reviewUser.review.createdTime))
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        .frame(width: 305, height: 188)
                        .padding()
                        .background(Color("Dark2"))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                    }
                    
                }
                .padding(.horizontal)
            }
        }
    }
}


#Preview {
    let sampleUser = UsersRecord(
        id: "user123",
        createdTime: "0000-00-00T00:00:00Z",
        fields: TentacledFields(
            name: "Afnan Abdullah",
            password: "Xxxx234@gmail.com",
            email: "Xxxx234@gmail.com",
            profileImage: "https://i.pinimg.com/736x/ac/a4/11/aca411921c641b0957d01f108ed0751f.jpg"
        )
    )

    let sampleReview = ReviewsRecord(
        id: "review123",
        createdTime: "0000-00-00T00:00:00Z",
        fields: PurpleFields(
            reviewText: "This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief to its glowingly benign view of human nature.",
            rate: 4, // ⭐⭐⭐⭐ Rating
            movieID: "reca1oIIcB4R3HVgw",
            userID: "user123"
        )
    )

    let sampleMovie = MoviesRecord(
        id: "reca1oIIcB4R3HVgw",
        createdTime: "0000-00-00T00:00:00Z",
        fields: IndigoFields(
            name: "Top Gun",
            rating: "",
            genre: ["Action"],
            poster: "https://i.imghippo.com/files/snS1877oNU.jpg",
            language: ["English"],
            imDBRating: 9.6,
            runtime: "2 hr 9 min",
            story: "Pete “Maverick” Mitchell is a hotshot Navy pilot whose skill is as legendary as his reckless streak..."
        )
    )

    ReviewsCard(movie: sampleMovie)
        .environmentObject(movieViewModel()) // ✅ Properly setting the environment object
}



