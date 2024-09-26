//
//  ContentView.swift
//  funny-face-filter
//
//  Created by Peter Grapentien on 9/25/24.
//

import SwiftUI

/*
    Display selected image and buttons here
 */

struct ContentView: View {
    @StateObject var viewModel: ImageViewModel
    
    var body: some View {
        VStack {
            if let image = viewModel.photoPickerViewModel.selectedPhoto?.image {
                Image(uiImage: image)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ImageViewModel(photoPickerViewModel: PhotoPickerViewModel()))
}
