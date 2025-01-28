//
//   ProfileInfo.swift
//  Movieisme
//
//  Created by Noori on 26/01/2025.
//

import SwiftUI

struct ProfileInfo: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var movieVM : movieViewModel
    @StateObject private var imageVM = imageSelectorVM()
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @State private var isEditing = false
    @State private var showErrorAlert = false
    @State private var showAlertSignOut = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                Spacer().frame(height: 40)
                
                if let user = movieVM.loggedInUser{
                    ZStack(){
                        
                        // Profile Image
                        AsyncImage(url: URL(string: user.fields.profileImage)) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 54, height: 60)
                                .clipShape(Circle())
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 78, height: 78)
                        .background(Color.white.opacity(0.21))
                        .clipShape(Circle())
                        
                        // Camera Icon
                        if isEditing {
                            Button(action: {
                                imageVM.presentImagePicker()
                            }) {
                                Image(systemName: "camera")
                                    .frame(width: 30, height: 24)
                                    .foregroundColor(.accent)
                                    .frame(width: 78, height: 78)
                                    .background(Color.white.opacity(0.5))
                                    .clipShape(Circle())
                            }

                        }
                    }
                    
                }
                else{
                    
                    Image("person")
                        .resizable()
                        .background(Color.white.opacity(0.21))
                        .frame(width: 78, height: 78)
                        .clipShape(Circle())
                    
                }
                
                
                
                //MARK: - name
                
                let firstName = movieVM.loggedInUser?.fields.name.split(separator: " ").first ?? ""
                let lastName = movieVM.loggedInUser?.fields.name.split(separator: " ").dropFirst().joined(separator: " ") ?? ""
                
                Form {
                    Section {
                        HStack {
                            Text("First name")
                                .font(.system(size: 18, weight: .medium))
                            Spacer().frame(width: 50)
                            
                            if isEditing {
                                TextField("First name", text: $firstName)
                                    .font(.system(size: 18))
                            } else {
                                Text(firstName)
                                    .font(.system(size: 18, weight: .regular))
                            }

                        }
                        .padding(.vertical, 8)
                        
                        HStack {
                            Text("Last name")
                                .font(.system(size: 18, weight: .medium))
                            Spacer().frame(width: 50)
                            if isEditing {
                                TextField("Last name", text: $lastName)
                                    .font(.system(size: 18))
                            } else {
                                Text(lastName)
                                    .font(.system(size: 18, weight: .regular))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                

                
                Spacer()
                
                //MARK: - signout
                
                if !isEditing {
                   Button(action: {
                       movieVM.logoutUser()
                       showAlertSignOut.toggle()
                   }) {
                       Text("Sign Out")
                   }
                   .buttonStyle(signoutButton())
                   .padding(.horizontal)
                }
                
                
                //MARK: - ending
            }
            .toolbar(){
               
                
                ToolbarItem(placement: .principal){
                    Text(isEditing ? "Edit profile" : "Profile info")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                // Edit button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                        if isEditing {
                            // Save changes
                            movieVM.updateUserName(firstName: firstName, lastName: lastName) { success in
                                if success {
                                    isEditing = false // Exit edit mode only after successful update
                                } else {
                                    showErrorAlert = true // Show error alert if update fails
                                }
                            }
                        } else {
                            // Enter edit mode
                            isEditing = true
                        }
//                       movieVM.loggedInUser?.fields.name = "\(firstName) \(lastName)"
//                       isEditing.toggle() // Exit edit mode
//                        movieVM.updateUserName(firstName: firstName, lastName: lastName){ success in
//                            if success {
//                                isEditing.toggle() // Exit edit mode
//                            }
//                        }
                        
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                }
                
            }
            .navigationBarTitleDisplayMode(.inline) // Inline title
            .overlay(
                Rectangle()
                    .frame(height: 1) // Line height
                    .frame(maxWidth: .infinity) // Full width
                    .foregroundColor(Color("Dark2")), // Line color
                alignment: .top
            )
            .onAppear {
               if let user = movieVM.loggedInUser {
                   firstName = user.fields.name.split(separator: " ").first.map(String.init) ?? ""
                   lastName = user.fields.name.split(separator: " ").dropFirst().joined(separator: " ")
               }
           }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Failed to update user. Please try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .actionSheet(isPresented: $showAlertSignOut) {
                ActionSheet(title: Text("Sign Out Confirmation"),
                    message: Text("Are you sure you want to sign out?"),
                    buttons: [
                        .cancel(),
                        .destructive(
                            Text("Sign Out")
//                            action:
                        )
                    ]
                )
            }
            
            
            
        }// end navigation stack
    }
}

#Preview {
    ProfileInfo()
        .environmentObject(movieViewModel())
}
