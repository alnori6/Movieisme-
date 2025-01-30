//
//  SignUp.swift
//  Movieisme
//
//  Created by Noori on 16/01/2025.
//

import SwiftUI

struct SignUp: View {
    @State var email: String = ""
    @State var password: String = ""
    
    @State var showSignIn: Bool = false
    @State var loginError: String? = nil // Error message for invalid login
    
    @FocusState private var focusedField: FocusField? // Track which field is focused
    
    @EnvironmentObject private var movieVM : movieViewModel
    
    enum FocusField {
        case email
        case password
    }
    
    var body: some View {
        
        ZStack {
            Image("signin_background")
                .resizable()
                .scaleEffect(1.3)
                .ignoresSafeArea(edges: .all)
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(1.3), Color.black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea(edges: .all)
            
            
            VStack(alignment: .leading){
                Spacer()
                
                //MARK: - title
                Text("Sign up")
                    .font(.system(size: 40, weight: .bold, design: .default))
//                    .foregroundStyle(.white)
                    .padding(.bottom, 8)
                
                Text("You'll find what you're looking for in the ocean of movies")
                    .font(.system(size: 18, weight: .medium, design: .default))
//                    .foregroundStyle(.white)
                    .layoutPriority(3)
                
//                    .padding(.bottom, 32)
                Spacer()
                    .frame(height: 32)
                
                //MARK: - Email
                Text("Email")
                    .font(.system(size: 18, weight: .medium, design: .default))
//                    .foregroundStyle(.white)

                
                TextField("",text: $email)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .padding()
//                    .foregroundStyle(.white)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(focusedField == .email ? Color.accent : Color.clear, lineWidth: 2) // Yellow border when focused
                    )
                    .focused($focusedField, equals: .email)
                    .placeholder(when: email.isEmpty, placeholder: {
                        Text("Enter your email")
                            .padding()
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(.gray) // Placeholder color

                    })
                    
                
                Spacer()
                    .frame(height: 32)
                
                //MARK: - password
                Text("Password")
                    .font(.system(size: 18, weight: .medium, design: .default))
//                    .foregroundStyle(.white)
                
                
                SecureField("", text: $password)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .padding()
//                    .foregroundColor(.white) // Typed text color
                    .background(Color.white.opacity(0.4)) // Background color
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(focusedField == .password ? Color.accent : Color.clear, lineWidth: 2) // Yellow border when focused
                            // Change stroke color to red if loginError exists
                            .stroke(loginError != nil ? Color("errorColor") : (focusedField == .password ? Color.accent : Color.clear), lineWidth: 2)
                    )
                    .focused($focusedField, equals: .password)
                    .placeholder(when: password.isEmpty, placeholder: {
                        Text("Enter your password")
                            .padding()
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(.gray) // Placeholder color
                    })
                    
                
                    
                    
                // MARK: - Error Message
               if let loginError = loginError {
                   Text(loginError)
                       .foregroundColor(.red)
                       .font(.system(size: 14, weight: .regular))
                       .padding(.bottom, 8)
               }
                               
                    
                
                Spacer()
                    .frame(height: 41)
                
                // MARK: - button sign in
                    
                if email.isEmpty || password.isEmpty {
                    Button("Sign in") {
                        focusedField = nil
                    }
                    .disabled(true)
                    .buttonStyle(grayButton())
                } else {
                    Button("Sign in") {
                        focusedField = nil
//                        showSignIn.toggle()
                        
                        // Validate user login
                        if movieVM.validateUser(email: email, password: password) {
                            movieVM.saveLoggedInUser() // Save the user session
                            showSignIn.toggle()
                        } else {
                            loginError = "Invalid password."
                        }
                    }
                    .disabled(false)
                    .buttonStyle(yellowButton())
                    .fullScreenCover(isPresented: $showSignIn) {
                        Home()
                            .environmentObject(movieVM)
                    }
                }
                
                    
            } // end vstack
            .padding(.all, 8)
            
            
        } // end zstack big
        .onTapGesture {
            focusedField = nil // Clear focus when tapping outside
        }
        .onAppear {
            movieVM.loadUsers()
            movieVM.loadLoggedInUser() // Load stored session
            
            // If the user is already logged in, go directly to Home
            if movieVM.loggedInUser != nil {
                showSignIn = true
            }
        }
        
        
        
    }
}


// MARK: - Placeholder Modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        placeholder: @escaping () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

#Preview {
    SignUp()
        .environmentObject(movieViewModel())
}
