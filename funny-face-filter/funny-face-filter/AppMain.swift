//
//  FunnyFaceApp.swift
//  funny-face-filter
//
//  Created by Peter Grapentien on 9/26/24.
//

import SwiftUI
import PhotosUI

@main
struct AppMain: App {
    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

