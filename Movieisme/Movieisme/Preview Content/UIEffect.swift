//
//  UIEffect.swift
//  Amer
//
//  Created by Noori on 25/12/2024.
//


import SwiftUI

// Primary button style with a pressed effect.
struct yellowButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.accent
            configuration.label
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(Color("Dark1"))
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .shadow(radius: 7, x: 0, y: 5)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}


/// Secondary button style with a pressed effect.
struct grayButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color("Dark4")
            configuration.label
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(Color("Dark3"))
        }
        .frame(height: 52)
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .shadow(radius: 7, x: 0, y: 5)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut, value: configuration.isPressed)
    }
}


struct cancleYellow: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color.clear
            configuration.label
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(Color.accent)
        }
        .frame(height: 52)
        
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.accent, lineWidth: 2) // Added border with the same color as text
                .shadow(radius: 7, x: 0, y: 5)
        )
        .cornerRadius(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}



struct UIEffect: View {
    var body: some View {
        
        Button("BlueButton") {
            
        }.buttonStyle(yellowButton()).padding()
        
        Button("GreenButton") {
            
        }.buttonStyle(grayButton()).padding()
        
        
        Button("cnacleGreen") {
            
        }.buttonStyle(cancleYellow()).padding()
        
       
        
    }
    
}


#Preview {
    UIEffect()
}
