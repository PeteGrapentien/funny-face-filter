//
//  PhotoPickerViewModel.swift
//  funny-face-filter
//
//  Created by Peter Grapentien on 9/26/24.
//

import SwiftUI
import PhotosUI

struct Photo: Identifiable {
    let id = UUID()
    let image: UIImage
}

@MainActor
class PhotoPickerViewModel: ObservableObject {
    @Published var selectedPhoto: Photo?
    @Published var pickerPhoto: PhotosPickerItem? {
        didSet {
            if let item = pickerPhoto {
                loadPhoto(from: item)
            }
        }
    }
    
    private func loadPhoto(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self, completionHandler: { result in
            switch result {
            case .success(let data):
              if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                  self.selectPhoto(image)
                }
              }
            case .failure(let error):
              print("Error loading photo: \(error.localizedDescription)")
            }
        })
    }
    
    func selectPhoto(_ photo: UIImage) {
      selectedPhoto = Photo(image: photo)
    }
/*
 
    1.) Load photo from picker
    2.) Expose through variable
 
 */
    
}
