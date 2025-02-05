//
//  Untitled.swift
//  WindowProject
//
//  Created by Ahmed Kadri on 1/19/25.
//

import SwiftUI

struct SampleView: View {
    
    var color: Color
    var text: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
            Text(text)
                .font(.extraLargeTitle)
        }
    }
}

#Preview {
    SampleView(color: .blue, text: "Hello")
}
