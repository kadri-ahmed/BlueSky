//
//  VisionOS_VRApp.swift
//  VisionOS_VR
//
//  Created by Ahmed Kadri on 1/19/25.
//

import SwiftUI

@main
struct VisionOS_VRApp: App {
    
    @State var immersionMode: ImmersionStyle = .full
    
    var body: some Scene {
        WindowGroup {
            ImmersiveControlView()
        }
        .defaultSize(width: 10, height: 10)
        .windowStyle(.plain)
        
        // VR
        ImmersiveSpace(id: "ImmersiveView"){
            // VR View
            ImmersiveView()
        }
        .immersionStyle(selection: $immersionMode, in: .full)
    }
}
