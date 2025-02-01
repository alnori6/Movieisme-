//
//  AddReviews.swift
//  Movieisme
//
//  Created by Noori on 30/01/2025.
//

import SwiftUI

struct AddReviews: View {
    @EnvironmentObject private var movieVM: movieViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let movie: MoviesRecord
    let maxRating: Int = 5
    @State private var rating: Int = 0 // Stores selected rating
    
    @State private var title: String = ""
    @State private var review: String = ""
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                HStack(){
                    AsyncImage(url: URL(string: movie.fields.poster)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipped(antialiased: true)
                            .cornerRadius(8)
                        
                    } placeholder: {
                        ProgressView("Loading...")
                            .frame(width: 150, height: 150)
                            .background(Color.white.opacity(0.21))
                            .cornerRadius(8)
                    }
                    .padding(8)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text(movie.fields.name)
                            .font(.system(size: 28, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        Text("\(movie.fields.genre.joined(separator: ", "))")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("Dark4"))
                    }
                    
                    Spacer()
                }
                
                Divider()
                    .background(Color("Dark3"))
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                
                Spacer().frame(maxHeight: 32)
                
                HStack{
                    Text("Tap to rate:")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("Dark3"))
                    Spacer()
                    HStack(spacing: 0) {
                        ForEach(1...maxRating, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.system(size: 28, weight: .medium, design: .default))
                                .onTapGesture {
                                    rating = index // Update rating when tapped
                                }
                        }
                    }
                }.padding(.horizontal)
                
                
                
                Form {
                    Section {
//                        HStack {
//                            Text("Title")
//                                .font(.system(size: 18, weight: .medium))
//                            Spacer().frame(width: 50)
//                            
//                            TextField("Write a title", text: $title)
//                                .font(.system(size: 18))
//
//
//                        }
//                        .padding(.vertical, 8)
                        
                        HStack {
                            Text("Review")
                                .font(.system(size: 18, weight: .medium))
                                .padding(.top, -25)
                            Spacer().frame(width: 25)
                            
                            TextEditor(text: $review)
                                .font(.system(size: 18))
                                .frame(minHeight: 50, maxHeight: 200) // Adjust height dynamically
                                .placeholder(when: review.isEmpty, placeholder: {
                                    Text("Optional")
                                        .font(.system(size: 18))
                                        .padding(.top, -25)
                                        .padding(.horizontal, 5)
                                        .foregroundColor(.gray.opacity(0.6)) // Placeholder color
                                })
                                
                            
                        }
                        .padding(.vertical, 8)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                
                
                Spacer().frame(maxHeight: 32)
                
                HStack(){
                    Text("Nickname:")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("Dark3"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    
                    if let user = movieVM.loggedInUser{
                        Text(user.fields.name)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("Dark3"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }.padding(.horizontal)
               
                
                
                Spacer()
                
            }// end big vstack
            .onTapGesture {
                movieVM.hideKeyboard()
            }
            .onAppear(){
                movieVM.loadAllData()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(){
                ToolbarItem(placement: .principal){
                    Text("Add Review")
                        .font(.system(size: 22, weight: .semibold))
                }
                ToolbarItem(placement: .cancellationAction){
                    Button(action: {
//                        title = ""
                        review = ""
                        rating = 0
                        
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Cancle")
                            .foregroundColor(.accent)
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button(action: {
                        guard !review.isEmpty, rating > 0 else {
                               print("🚨 Review text or rating is missing!")
                               return
                           }

                           movieVM.submitReview(
                               reviewText: review,
                               rating: rating,
                               movie: movie
                           ) { success in
                               if success {
                                   DispatchQueue.main.async {
                                       presentationMode.wrappedValue.dismiss() // ✅ Close the view after submission
                                   }
                               } else {
                                   print("❌ Failed to submit review.")
                               }
                           }
                    }){
                        Text("Submit")
                    }
                    .disabled(rating <= 0 || review.isEmpty)
                }
            }
        }// end navigation
        
        
    }
    
}


#Preview {
    AddReviews(
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
        
    )
        .environmentObject(movieViewModel())
}
