//
//  FrameworkGridViewModel.swift
//  Apple-Frameworks
//
//  Created by Ahmed Kadri on 1/28/25.
//

import SwiftUI

// final for a class that will not subclassed
final class FrameworkGridViewModel: ObservableObject { // allow our object to publish information
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
}
