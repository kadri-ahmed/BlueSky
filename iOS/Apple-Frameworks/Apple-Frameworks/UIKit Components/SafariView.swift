//
//  SafariView.swift
//  Apple-Frameworks
//
//  Created by Ahmed Kadri on 1/28/25.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable{
    
    let url: URL
    
    func makeUIViewController (context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController (_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}
