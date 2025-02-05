//
//  ContentView.swift
//  WindowProject
//
//  Created by Ahmed Kadri on 1/19/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct StartingWindow: View {
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack {
            Image(systemName: "visionpro")
                .font(.system(size: 150))
                .symbolEffect(.pulse)
                .bold()
            
            HStack {
                Button("Window 1"){
                    // Action when Pressed
                    openWindow(id: "Window 1")
                }
                
                Button("Window 2"){
                    // Action event
                    openWindow(id: "Window 2")
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    StartingWindow()
}
