//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Ahmed Kadri on 1/31/25.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
    @Published var scannedBarcode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String {
        scannedBarcode.isEmpty ? "Not Yet Scanned" : "Scanned barcode: \(scannedBarcode)"
    }
    
    var statusTextColor: Color {
        scannedBarcode.isEmpty ? .red : .green
    }
}
