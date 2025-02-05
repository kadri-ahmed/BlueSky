//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Ahmed Kadri on 1/31/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: "Something is wrong with the camera. We are unable to capture the input.",
                                              dismissButton: .default(Text("OK")))
    
    static let invalidScanInput = AlertItem(title: "Invalid Scan Input",
                                            message: "The value scanned is not valid. This app scans EAN-8 and EAN-13 barcodes only.",
                                            dismissButton: .default(Text("OK")))
}
