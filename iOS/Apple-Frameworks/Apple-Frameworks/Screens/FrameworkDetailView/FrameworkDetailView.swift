//
//  FrameworkDetailView.swift
//  Apple-Frameworks
//
//  Created by Ahmed Kadri on 1/27/25.
//

import SwiftUI

struct FrameworkDetailView: View {
    
    var framework: Framework
    @State private var isShowingSafariView = false
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            FrameworkTitleView(framework: framework)
            
            Text(framework.description)
                .font(.body)
                .padding()
            
            Spacer()
            
            Button {
                isShowingSafariView = true
            } label: {
                AFButton(title: "Learn More")
            }
        }
        .fullScreenCover(isPresented: $isShowingSafariView, content: {
            SafariView(url: URL(string: framework.urlString) ?? URL(string: "https://www.apple.com")!)
        })
//        .fullScreenCover(isPresented: $isShowingSafariView, content: {
//            SafariView(url: URL(string: framework.urlString) ?? URL(string: "https://www.apple.com")!)
//        })
    }
}

#Preview {
    FrameworkDetailView(framework: MockData.sampleFramework)
}
