//
//  FrameworkGridView.swift
//  Apple-Frameworks
//
//  Created by Ahmed Kadri on 1/27/25.
//

import SwiftUI

struct FrameworkGridView: View {
    
    @StateObject var viewModel = FrameworkGridViewModel() // stays alive when view gets destroyed and recreated
    
    
    
    var body: some View {
        
        NavigationView{
            List {
                ForEach(MockData.frameworks){ framework in
                    NavigationLink(destination: FrameworkDetailView(framework: framework, isShowingDetailView: $viewModel.isShowingDetailView))
                    {
                        FrameworkTitleView(framework: framework)
                        
                    }
                }
            }
            .navigationTitle("🍎 Frameworks")
        }
        .accentColor(Color(.label))
    }
    
}


#Preview {
    FrameworkGridView()
        .preferredColorScheme(.dark)
}


