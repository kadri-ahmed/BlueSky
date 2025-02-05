//
//  ContentView.swift
//  Pipeline
//
//  Created by Ahmed Kadri on 12/24/24.
//

import SwiftUI
import MetalKit 

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
                .border(Color.black, width: 2)
            Text("Hello Metal!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
