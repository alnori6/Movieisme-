//
//  Profile.swift
//  Movieisme
//
//  Created by Noori on 25/01/2025.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject private var movieVM : movieViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        
        NavigationStack{
                
            VStack(){
                
                // Display user info if logged in
                if let user = movieVM.loggedInUser {
                    HStack{
                        // Profile Image
                        AsyncImage(url: URL(string: user.fields.profileImage)) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                                
                        } placeholder: {
                            ProgressView()
                                .frame(width: 56, height: 56)
                                .background(Color.white.opacity(0.21))
                                .clipShape(Circle())
                        }
                        .frame(width: 56, height: 56)
                        .background(Color.white.opacity(0.21))
                        .clipShape(Circle())
                        
                        // User Details
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fields.name)
                                .font(.system(size: 18, weight: .medium))
                            Text(user.fields.email)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        NavigationLink(destination: ProfileInfo()){
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 80)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(8)
                    .padding()
                    
                }else{
                    HStack(spacing: 8){
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                            
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("No user logged in.")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.red)
                            Text("No user email available.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.red)
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 80)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(8)
                    .padding()
                   
                }
                
                Spacer().frame(height: 52)
                
                Text("Saved movies")
                    .font(.system(size: 22, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                
                
                
                
                let savedMovies = movieVM.getSavedMovies()

                if !savedMovies.isEmpty {
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(savedMovies,id: \.id) { movie in
                                    
                                    NavigationLink(destination: MovieInfo(movie: movie)) {
                                        MovieMiniCard(movie: movie)
                                            .frame(width: 172, height: 237) // Maintains correct size
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: 172, height: 237)
                                }
                            }
                            .padding(.horizontal, 16)
                            
                        }
                        .padding(.top, 8)
                            
                    }
                    
                } else {
                    VStack {
                        Spacer().frame(height: 120)
                        Image("logo_back")
                            .resizable()
                            .frame(width: 73, height: 50)
                            .padding()
                        
                        Text("No saved movies yet, start saving your favorites.")
                            .font(.system(size: 14, weight: .medium))
                            .frame(width: 219)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Dark3"))
                    }
                    .padding(.top, 32)
                }
                                    
                
                
            }// end big vstack
            .navigationTitle(
                Text("Profile")
                    .font(.system(size: 28, weight: .bold, design: .default))
            )
            .navigationBarTitleDisplayMode(.large)
            
        }
        
        
    }
}

#Preview {
    Profile()
        .environmentObject(movieViewModel())
}
