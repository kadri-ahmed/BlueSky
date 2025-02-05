//
//  ContentView.swift
//  VolumesProject
//
//  Created by Ahmed Kadri on 1/22/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        ZStack {
            // Astraunout image
            Image("astronaut")
                .resizable()
                .scaledToFill()
            
            // Button
            Button("Explore More") {
                // Do something
                openWindow(id: "Volume")
            }
            .controlSize(.extraLarge)
            
            // 3D Model -- limited to static models
//            Model3D(named: "Astraunaut") { model in
//                model
//            } placeholder: {
//                ProgressView()
//            }
            
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
