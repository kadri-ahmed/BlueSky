//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Ahmed Kadri on 1/30/25.
//

import SwiftUI

struct BarcodeScannerView: View {
    // new viewModel -> StateObject
    // passing a viewModel in -> ObservedObject
    @StateObject var viewModel = BarcodeScannerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannerCode: $viewModel.scannedBarcode, alertItem: $viewModel.alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer()
                    .frame(height: 60)
                
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text(viewModel.statusText)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(viewModel.statusTextColor)
                    .padding()
                
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: Text(alertItem.title),
                      message: Text(alertItem.message),
                      dismissButton: alertItem.dismissButton)
                
            }
        }
    }
}

#Preview {
    BarcodeScannerView()
}
