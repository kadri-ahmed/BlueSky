//
//  WindowProjectApp.swift
//  WindowProject
//
//  Created by Ahmed Kadri on 1/19/25.
//

import SwiftUI

// Only Starting Window Visible because visionOS by default opens
// the first window

@main
struct WindowProjectApp: App {
    var body: some Scene {
        WindowGroup(id: "Starting Window") {
            StartingWindow()
        }
        .defaultSize(CGSize(width: 600, height: 400))
        
        WindowGroup(id: "Window 1"){
            SampleView(color: .blue, text: "Window 1")
        }
        
        WindowGroup(id: "Window 2"){
            SampleView(color: .red, text: "Window 2")
        }
    }
}
