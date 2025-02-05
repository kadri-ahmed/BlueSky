//
//  ContentView.swift
//  VisionOS_VR
//
//  Created by Ahmed Kadri on 1/19/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveControlView: View {
    
    // these live as long as the app is running
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dimissImmersiveSpace
    
    var body: some View {
        VStack {
            Button{
                // Present VR World
                Task {
                    await openImmersiveSpace(id: "ImmersiveView")
                }
                
            } label: {
                Image(systemName: "visionpro")
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ImmersiveControlView()
}
