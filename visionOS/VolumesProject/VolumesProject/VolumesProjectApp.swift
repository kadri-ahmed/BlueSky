//
//  VolumesProjectApp.swift
//  VolumesProject
//
//  Created by Ahmed Kadri on 1/22/25.
//

import SwiftUI

@main
struct VolumesProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        // Volumes
        WindowGroup(id: "Volume") {
            AstraunautExperience()
        }
        .windowStyle(.volumetric)
    }
}
